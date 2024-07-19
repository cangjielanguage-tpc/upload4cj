/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights resvered.
 */

package upload4cj


/**
 * Provides access to the request information needed for a request made to
 * an HTTP servlet
 */
public class DeferredFileOutputStream <: ThresholdingOutputStream {
    private var memoryOutputStream: ?ByteArrayStream = Option<ByteArrayStream>.None
    private var currentOutputStream: OutputStream
    private var outputFile: Option<File> = Option<File>.None
    private var mTempFile: Option<File>
    private var mRepository: Option<Directory>
    private var prefix: ?String = Option<String>.None
    private var suffix: ?String = Option<String>.None
    private var directory: ?File = Option<File>.None
    private var closed: Bool

    private static let UID: String = Generators.randomBasedGenerator().generate().toString().replace("-", "_")
    private static let COUNTER = AtomicInt64(0)

    static let mtx = ReentrantMutex()
    /**
     * DeferredFileOutputStream init
     *
     * @param threshold - Int64
     * @param outputFile - Option<File>
     * @param repository - Option<Directory>
     */
    public init(threshold: Int64, tempFile: Option<File>, repository: Option<Directory>) {
        this(threshold, tempFile, repository, Option<String>.None, Option<String>.None, Option<File>.None)
    }

    init(
        threshold: Int64,
        tempFile: Option<File>,
        repository: Option<Directory>,
        prefix: Option<String>,
        suffix: Option<String>,
        directory: Option<File>
    ) {
        super(threshold)
        this.closed = false
        this.mTempFile = tempFile
        this.mRepository = repository
        this.memoryOutputStream = ByteArrayStream()
        this.currentOutputStream = this.memoryOutputStream.getOrThrow()
        this.prefix = prefix
        this.suffix = suffix
        this.directory = directory
    }

    /**
     * close
     */
    public func close(): Unit {
        if(let Some(i) <- outputFile){
            i.close()
        }
        this.closed = true
    }

    /**
     * get memory data
     *
     * @return - Option<Array<UInt8>> data Array
     */
    public func getData(): Option<Array<UInt8>> {
        if (let Some(_) <- this.memoryOutputStream) {
            return this.memoryOutputStream.getOrThrow().bytes()
        } else {
            return Option<Array<UInt8>>.None
        }
    }

    /**
     * lcoal stored file
     *
     * @return - File file
     */
    public func getFile(): Option<File> {
        return this.outputFile
    }

    protected override func getStream(): OutputStream {
        return this.currentOutputStream
    }

    /**
     * be stored in memory or not
     *
     * @return - Bool
     */
    public func isInMemory(): Bool {
        return !this.isThresholdExceeded()
    }

    private func createOutputFile(): File {
        if (let Some(i) <- mTempFile) {
            return i
        } else {
            var tempDir: Option<Directory> = mRepository
            let dirName = "tempDir"
            var pathDir: Path = Path(dirName)
            if (let Some(j) <- tempDir) {
                pathDir = j.info.path
            } else {
                mtx.lock()
                if (!Directory.exists(pathDir)) {
                    tempDir = Directory.create(pathDir)
                }
                mtx.unlock()
            }
            let tempFileName: String = "upload_" + UID + getUniqueId() + ".tmp"
            let path: Path = pathDir.join(tempFileName)
            mTempFile = File(path, OpenOption.Create(true))
        }
        return mTempFile.getOrThrow()
    }

    private static func getUniqueId(): String {
        let limit: Int64 = 100000000000
        let current: Int64 = COUNTER.fetchAdd(1)
        var id: String = current.toString()
        if (current < limit) {
            id = ("00000000000" + id).substring(id.size)
        }
        return id
    }

    protected override func thresholdReached(): Unit {
        //真正要写的时候才创建
        this.outputFile = createOutputFile()
        this.outputFile.getOrThrow().write(this.memoryOutputStream.getOrThrow().bytes())
        this.currentOutputStream = outputFile.getOrThrow()
        this.memoryOutputStream = Option<ByteArrayStream>.None
        return
    }
}

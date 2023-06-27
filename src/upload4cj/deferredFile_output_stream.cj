package upload4cj

from std import fs.*

public class DeferredFileOutputStream <: ThresholdingOutputStream {
    private var memoryOutputStream: ?ByteArrayStream = Option<ByteArrayStream>.None
    private var currentOutputStream: OutputStream
    private var outputFile:Option<File> = Option<File>.None
    private var mTempFile:Option<File>
    private var mRepository:Option<Directory>
    private var prefix: ?String = Option<String>.None
    private var suffix: ?String = Option<String>.None
    private var directory: ?File = Option<File>.None
    private var closed: Bool

    private static let UID: String = Generators.randomBasedGenerator().generate().toString().replace('-', '_')
    private static let COUNTER = AtomicInt64(0)

    public init(threshold: Int64, tempFile: Option<File>,repository:Option<Directory>) {
        this(threshold, tempFile,repository,Option<String>.None, Option<String>.None, Option<File>.None)
    }

    init(threshold: Int64, tempFile: Option<File>,repository:Option<Directory>,prefix: Option<String>, suffix: Option<String>, directory: Option<File>) {
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

    public func close(): Unit {
        this.closed = true
    }

    public func getData(): Option<Array<UInt8>> {
        if(let Some(i) = this.memoryOutputStream){
            return this.memoryOutputStream.getOrThrow().bytes()
        }else{
            return Option<Array<UInt8>>.None
        }
    }

    public func getFile(): Option<File> {
        return this.outputFile
    }

    protected override func getStream(): OutputStream {
        return this.currentOutputStream
    }

    public func isInMemory(): Bool {
        return !this.isThresholdExceeded()
    }

    private func createOutputFile():File{
         if (let Some(i) = mTempFile) {
            return i
        } else {
            var tempDir: Option<Directory> = mRepository
            let dirName = "tempDir"
            var pathDir: Path = Path(dirName)
            if (let Some(j) = tempDir) {
                pathDir = j.info.path
            } else {
                if (!Directory.exists(pathDir)) {
                    tempDir = Directory.create(pathDir)
                }
            }
            let tempFileName: String = "upload_" + UID + getUniqueId() + ".tmp"
            let path: Path = pathDir.join(tempFileName)
            mTempFile = File(path, OpenOption.Create(true))
        }
        return mTempFile.getOrThrow()
    }

    private static func getUniqueId(): String {
        let limit: Int64 = 100000000
        let current: Int64 = COUNTER.fetchAdd(1)
        var id: String = current.toString()
        if (current < limit) {
            id = ("00000000" + id).substring(id.size)
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

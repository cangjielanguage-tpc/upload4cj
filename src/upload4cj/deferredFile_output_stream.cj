package upload4cj

from std import fs.*

public class DeferredFileOutputStream <: ThresholdingOutputStream {
    private var memoryOutputStream: ?ByteArrayStream = Option<ByteArrayStream>.None
    private var currentOutputStream: OutputStream
    private var outputFile: File
    private var prefix: ?String = Option<String>.None
    private var suffix: ?String = Option<String>.None
    private var directory: ?File = Option<File>.None
    private var closed: Bool

    public init(threshold: Int64, outputFile: File) {
        this(threshold, outputFile, Option<String>.None, Option<String>.None, Option<File>.None)
    }

    init(threshold: Int64, outputFile: File, prefix: Option<String>, suffix: Option<String>, directory: Option<File>) {
        super(threshold)
        this.closed = false
        this.outputFile = outputFile
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

    public func getFile(): File {
        return this.outputFile
    }

    protected override func getStream(): OutputStream {
        return this.currentOutputStream
    }

    public func isInMemory(): Bool {
        return !this.isThresholdExceeded()
    }

    protected override func thresholdReached(): Unit {
        this.outputFile.write(this.memoryOutputStream.getOrThrow().bytes())
        this.currentOutputStream = outputFile
        this.memoryOutputStream = Option<ByteArrayStream>.None
        return
    }
}

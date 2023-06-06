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

    init(threshold: Int64, outputFile: File) {
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
        let data = match (this.memoryOutputStream) {
            case Some(v) => this.memoryOutputStream.getOrThrow().bytes()
            case None => Option<Array<UInt8>>.None
        }
        return data
    }

    public func getFile(): File {
        return this.outputFile
    }

    public override func getStream(): OutputStream {
        return this.currentOutputStream
    }

    public func isInMemory(): Bool {
        return !this.isThresholdExceeded()
    }

    public override func thresholdReached(): Unit {
        return
    }
}

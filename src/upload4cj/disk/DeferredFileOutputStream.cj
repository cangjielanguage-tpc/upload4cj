package upload4cj.disk

public class DeferredFileOutputStream <: ThresholdingOutputStream {
    

    private var threshold: Int64 = 0
    private var memoryOutputStream: ByteArrayStream

    init(threshold: Int64) {
        super(1)
        this.memoryOutputStream = ByteArrayStream()

    }

    public override func getStream(): OutputStream {
        return ByteArrayStream()
    }

    public override func thresholdReached(): Unit {
        return
    }

    public func getData(): Array<UInt8> {
        return this.memoryOutputStream.bytes()
    }


}
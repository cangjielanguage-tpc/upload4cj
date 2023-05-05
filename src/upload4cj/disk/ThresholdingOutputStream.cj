package upload4cj.disk

public abstract class ThresholdingOutputStream <: OutputStream {

    private var threshold: Int64 
    private var written: Int64 = 0
    private var thresholdExceeded: Bool = true

    init(threshold: Int64) {
        this.threshold = threshold
    }

    public func write(b: Array<UInt8>) {
        this.checkThreshold(1)
        this.getStream().write(b)
        this.written = this.written + b.size
    }

    public func flush() {
        this.getStream().flush()
    }

    public func getThreshold(): Int64 {
        return this.threshold
    }

    public func getByteCount(): Int64 {
        return this.written
    }

    public func isThresholdExceeded(): Bool {
        return this.written > this.threshold
    }

    public func checkThreshold(count: Int64) {
        if (!this.thresholdExceeded && (this.written + count > this.threshold)) {
            this.thresholdExceeded = true
            this.thresholdReached()
        }
    }

    public func resetByteCount() {
        this.thresholdExceeded = false
        this.written = 0
    }

    public func getStream(): OutputStream
    public func thresholdReached(): Unit

}
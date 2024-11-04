/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package upload4cj

/**
 * ThresholdingOutputStream
 */
public abstract class ThresholdingOutputStream <: OutputStream {
    private var threshold: Int64
    private var written: Int64 = 0
    private var thresholdExceeded: Bool = false

    /**
     * init
     *
     * @param threshold - Int64 The size
     */
    public init(threshold: Int64) {
        this.threshold = threshold
    }

    protected func checkThreshold(count: Int64) {
        if (!this.thresholdExceeded && (this.written + count > this.threshold)) {
            this.thresholdExceeded = true
            this.thresholdReached()
        }
    }

    /**
     * stream flush
     */
    public func flush() {
        this.getStream().flush()
    }

    /**
     * get ByteCount
     *
     * @return Int64 - ByteCount
     */
    public func getByteCount(): Int64 {
        return this.written
    }

    protected func getStream(): OutputStream

    /**
     * get Threshold
     *
     * @return Int64 - Threshold
     */
    public func getThreshold(): Int64 {
        return this.threshold
    }

    /**
     * is ThresholdExceeded
     *
     * @return Bool - is ThresholdExceeded or not
     */
    public func isThresholdExceeded(): Bool {
        return this.written > this.threshold
    }

    protected func thresholdReached(): Unit

    /**
     * write
     *
     * @param b - Array<UInt8> The byte array
     */
    public func write(b: Array<UInt8>) {
        this.checkThreshold(b.size)

        //这个getStream 可能是memoryOutputStream  这是内存情况 ; 也可能是outputFile  这是非内存情况
        this.getStream().write(b)
        this.written = this.written + b.size
    }
}

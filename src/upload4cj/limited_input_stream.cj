/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

/**
 * LimitedInputStream
 */
public abstract class LimitedInputStream <: InterInputStream {
    /**
     * The input stream to be filtered.
     */
    private let input: InputStream

    /**
     * The maximum size of an item, in bytes.
     */
    private let sizeMax: Int64

    /**
     * The current number of bytes.
     */
    private var count: Int64 = 0

    /**
     * init
     *
     * @param inputStream - InputStream The InputStream
     * @param pSizeMax - Int64 The max size
     */
    public init(inputStream: InputStream, pSizeMax: Int64) {
        this.input = inputStream
        this.sizeMax = pSizeMax
    }

    protected func raiseError(pSizeMax: Int64, pCount: Int64): Unit

    private func checkLimit(): Unit {
        if (count > sizeMax) {
            raiseError(sizeMax, count)
        }
    }

    /**
     * read the buffer array
     *
     * @param buffer - Array<Byte> The buffer array
     * @return Int64 - the array size read
     */
    public override func read(buffer: Array<UInt8>): Int64 {
        let res: Int64 = input.read(buffer)
        if (res > 0) {
            count += res
            checkLimit()
        }
        return res
    }

    /**
     * close
     */
    public override func close(): Unit {}
}

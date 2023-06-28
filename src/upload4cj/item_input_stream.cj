/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

class ItemInputStream <: InterInputStream {
    private var total: Int64 = 0

    /**
     * The number of bytes, which must be hold, because
     * they might be a part of the boundary.
     */
    private var pad: Int64 = 0

    /**
     * The current offset in the buffer.
     */
    private var pos: Int64 = 0

    private var closed: Bool = false

    private let BYTE_POSITIVE_OFFSET: Int64 = 256

    private var mMultiPartStream: Option<MultipartStream>

    init(multiPartStream: Option<MultipartStream>) {
        this.mMultiPartStream = multiPartStream
        findSeparator()
    }

    private func findSeparator(): Unit {
        pos = mMultiPartStream.getOrThrow().findSeparator()
        if (pos == -1) {
            if (mMultiPartStream.getOrThrow().tail - mMultiPartStream.getOrThrow().head > mMultiPartStream.getOrThrow().
            keepRegion) {
                pad = mMultiPartStream.getOrThrow().keepRegion
            } else {
                pad = mMultiPartStream.getOrThrow().tail - mMultiPartStream.getOrThrow().head
            }
        }
    }

    protected func getBytesRead() {
        return total
    }

    protected func available(): Int64 {
        if (pos == -1) {
            return mMultiPartStream.getOrThrow().tail - mMultiPartStream.getOrThrow().head - pad
        }
        return pos - mMultiPartStream.getOrThrow().head
    }

    public override func read(buffer: Array<Byte>): Int64 {
        if (closed) {
            throw ItemSkippedException("Read Fail")
        }

        if (buffer.size == 0) {
            return 0
        }

        var res = available()
        if (res == 0) {
            res = makeAvailable()
            if (res == 0) {
                return -1
            }
        }

        res = min(res, buffer.size)

        mMultiPartStream.getOrThrow().buffer.copyTo(buffer, mMultiPartStream.getOrThrow().head, 0, res)
        mMultiPartStream.getOrThrow().head += res
        total += res
        return res
    }

    public override func close(): Unit {
        close(false)
    }

    protected func close(pCloseUnderlying: Bool): Unit {
        if (closed) {
            return
        }

        if (pCloseUnderlying) {
            closed = true
        } else {
            while (true) {
                var av = available()
                if (av == 0) {
                    av = makeAvailable()
                    if (av == 0) {
                        break
                    }
                }
                skip(av)
            }
        }
        closed = true
    }

    protected func skip(bytes: Int64): Int64 {
        if (closed) {
            throw ItemSkippedException("Skip Fail")
        }
        var av = available()
        if (av == 0) {
            av = makeAvailable()
            if (av == 0) {
                return 0
            }
        }
        let res: Int64 = min(av, bytes)
        mMultiPartStream.getOrThrow().head += res
        return res
    }

    private func makeAvailable(): Int64 {
        if (pos != -1) {
            return 0
        }
        total = total + (mMultiPartStream.getOrThrow().tail - mMultiPartStream.getOrThrow().head - pad)
        mMultiPartStream.getOrThrow().buffer.copyTo(mMultiPartStream.getOrThrow().buffer,
            mMultiPartStream.getOrThrow().tail - pad, 0, pad)
        mMultiPartStream.getOrThrow().head = 0
        mMultiPartStream.getOrThrow().tail = pad

        while (true) {
            var bufferTemp = mMultiPartStream.getOrThrow().buffer[mMultiPartStream.getOrThrow().tail..mMultiPartStream.
                getOrThrow().bufSize]
            var bytesRead: Int64 = mMultiPartStream.getOrThrow().input.read(bufferTemp)
            bufferTemp.copyTo(mMultiPartStream.getOrThrow().buffer, 0, mMultiPartStream.getOrThrow().tail,
                mMultiPartStream.getOrThrow().bufSize - mMultiPartStream.getOrThrow().tail)
            if (bytesRead == -1) {
                throw MalformedStreamException("Stream ended unexpectedly");
            }

            if (let Some(i) = mMultiPartStream.getOrThrow().notifier) {
                i.noteBytesRead(bytesRead)
            }

            mMultiPartStream.getOrThrow().tail = mMultiPartStream.getOrThrow().tail + bytesRead
            findSeparator()
            let av: Int64 = available()

            if (av > 0 || pos != -1) {
                return av
            }
        }
        return 0
    }
}

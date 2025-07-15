/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package upload4cj

/**
 * ItemInputStream
 */
class ItemInputStream <: InterInputStream {
    private var total: Int64 = 0

    private var pad: Int64 = 0

    private var pos: Int64 = 0

    private var closed: Bool = false

    private let BYTE_POSITIVE_OFFSET: Int64 = 256

    private var mMultiPartStream: MultipartStream

    init(multiPartStream: MultipartStream) {
        this.mMultiPartStream = multiPartStream
        findSeparator()
    }

    private func findSeparator(): Unit {
        pos = mMultiPartStream.findSeparator()
        if (pos == -1) {
            if (mMultiPartStream.tail - mMultiPartStream.head > mMultiPartStream.keepRegion) {
                pad = mMultiPartStream.keepRegion
            } else {
                pad = mMultiPartStream.tail - mMultiPartStream.head
            }
        }
    }

    protected func getBytesRead():Int64 {
        return total
    }

    protected func available(): Int64 {
        if (pos == -1) {
            return mMultiPartStream.tail - mMultiPartStream.head - pad
        }
        return pos - mMultiPartStream.head
    }

    /**
     * read the buffer array
     *
     * @param buffer - Array<Byte> The buffer array
     * @return Int64 - the array size read
     */
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

        mMultiPartStream.buffer.copyTo(buffer, mMultiPartStream.head, 0, res)
        mMultiPartStream.head += res
        total += res
        return res
    }

    /**
     * close
     */
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
        mMultiPartStream.head += res
        return res
    }

    private func makeAvailable(): Int64 {
        if (pos != -1) {
            return 0
        }
        total = total + (mMultiPartStream.tail - mMultiPartStream.head - pad)
        mMultiPartStream.buffer.copyTo(
            mMultiPartStream.buffer,
            mMultiPartStream.tail - pad,
            0,
            pad
        )
        mMultiPartStream.head = 0
        mMultiPartStream.tail = pad

        while (true) {
            var bytesRead: Int64 = mMultiPartStream.input.read(mMultiPartStream.buffer[mMultiPartStream.tail..mMultiPartStream.bufSize])

            if (bytesRead <= 0) {
                throw MalformedStreamException("Stream ended unexpectedly");
            }

            if (let Some(i) <- mMultiPartStream.notifier) {
                i.noteBytesRead(bytesRead)
            }

            mMultiPartStream.tail = mMultiPartStream.tail + bytesRead
            findSeparator()
            let av: Int64 = available()

            if (av > 0 || pos != -1) {
                return av
            }
        }
        return 0
    }
}

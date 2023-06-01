/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

public class ItemInputStream <: InputStream{

    private var total:Int64 = 0

    /**
     * The number of bytes, which must be hold, because
     * they might be a part of the boundary.
     */
    private var pad:Int64 = 0

    /**
     * The current offset in the buffer.
     */
    private var pos:Int64 = 0

    private var closed:Bool = false

    private let BYTE_POSITIVE_OFFSET: Int64 = 256

    private var mMultiPartStream:Option<MultipartStream>

    init(multiPartStream: Option<MultipartStream>){
        this.mMultiPartStream = multiPartStream
        findSeparator()
    }

    private func findSeparator():Unit{
        pos = mMultiPartStream.getOrThrow().findSeparator()
        if(pos == -1){
            if(mMultiPartStream.getOrThrow().tail - mMultiPartStream.getOrThrow().head > mMultiPartStream.getOrThrow().keepRegion) {
                pad = mMultiPartStream.getOrThrow().keepRegion
            } else {
                pad = mMultiPartStream.getOrThrow().tail - mMultiPartStream.getOrThrow().head
            }
        }
    }

    public func getBytesRead() {
        return total
    }

    public func available(): Int64 {
        if (pos == -1) {
            return mMultiPartStream.getOrThrow().tail - mMultiPartStream.getOrThrow().head - pad
        }
        return pos - mMultiPartStream.getOrThrow().head
    }

    public override func read(b: Array<UInt8>): Int64{
        if (closed) {
            throw ItemSkippedException()
        }
        var res = available()
        if (res == 0) {
            res = makeAvailable()
            if (res == 0) {
                return -1
            }
        }

        mMultiPartStream.getOrThrow().head += res
        total = total + res
        return res
    }

    public func makeAvailable():Int64 {
        if (pos != -1) {
            return 0
        }
        total = total + (mMultiPartStream.getOrThrow().tail - mMultiPartStream.getOrThrow().head - pad)
        mMultiPartStream.getOrThrow().buffer.copyTo(mMultiPartStream.getOrThrow().buffer, mMultiPartStream.getOrThrow().tail - pad, 0, pad)
        mMultiPartStream.getOrThrow().head = 0
        mMultiPartStream.getOrThrow().tail = pad

        while (true) {
            var bufferTemp = mMultiPartStream.getOrThrow().buffer[mMultiPartStream.getOrThrow().tail..mMultiPartStream.getOrThrow().bufSize]
            var bytesRead: Int64 = mMultiPartStream.getOrThrow().input.read(bufferTemp)
            bufferTemp.copyTo(mMultiPartStream.getOrThrow().buffer, 0, mMultiPartStream.getOrThrow().tail, mMultiPartStream.getOrThrow().bufSize - mMultiPartStream.getOrThrow().tail)
            if (bytesRead <= 0) {
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

    public func isClosed(): Bool {
        return closed
    }

    public func Close() {
        closed = true
    }
}

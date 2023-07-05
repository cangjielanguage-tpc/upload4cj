// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
from upload4cj import upload4cj.*
from net import http.*
from std import io.*

@OverflowWrapping
main() {
    let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"

    let NUM_ITEMS: Int64 = 3
    var baos = ByteArrayStream()

    for (i in 0..3) {
        let header: String = "-----1234\r\nContent-Disposition: form-data; name=\"field\"\r\n\r\n"

        baos.write(header.toUtf8Array())
        for (j in 0..1000 + i) {
            baos.write([UInt8(j)])
        }
        baos.write("\r\n".toUtf8Array())
    }
    baos.write("-----1234--\r\n".toUtf8Array())
    var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", baos)
    req1.header.add("Content-Type", CONTENT_TYPE)

    var servletRequestContext: ServletRequestContext = ServletRequestContext(req1)
    let srt: String = servletRequestContext.toString()
    let c: Int64 = runTest(NUM_ITEMS, baos.length, servletRequestContext)
    if (c == 1) {
        return 1
    }
    return 0
}

@OverflowWrapping
public func runTest(NUM_ITEM: Int64, pContentLength: Int64, request: ServletRequestContext): Int64 {
    let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())

    let listener: ProgressListenerImpl = ProgressListenerImpl(pContentLength, NUM_ITEM)

    upload.setProgressListener(listener)

    var iter: FileItemIterator = upload.getItemIterator(request)

    for (i in 0..3) {
        let stream: FileItemStream = iter.next()
        var istream: InputStream = stream.openStream()
        var bytes: Array<UInt8> = Array<UInt8>(16384 + i, item: 0)

        istream.read(bytes)

        for (j in 0..1000 + i) {
            if (bytes[j] != UInt8(j)) {
                return 1
            }
        }
    }
    let check: Int64 = listener.checkFinished()
    if (check != 0) {
        return 3
    }
    return 0
}

public class ProgressListenerImpl <: ProgressListener {
    private let expectedContentLength: Int64

    private let expectedItems: Int64

    private var bytesRead: Int64 = 0

    private var items: Int64 = 0

    public init(pContentLength: Int64, pItems: Int64) {
        expectedContentLength = pContentLength
        expectedItems = pItems
    }

    public override func update(pBytesRead: Int64, pContentLength: Int64, pItems: Int64) {
        bytesRead = pBytesRead
        items = pItems
    }

    public func checkFinished(): Int64 {
        if (bytesRead != expectedContentLength) {
            return 1
        }

        if (items != expectedItems) {
            return 2
        }
        return 0
    }
}

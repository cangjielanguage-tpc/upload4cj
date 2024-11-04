// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import upload4cj.*
import net.http.*
import std.io.*
import std.unittest.*
import std.unittest.testmacro.*

@OverflowWrapping
main() {
    test1()
}

@OverflowWrapping
func test1(): Unit {
    let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"

    let NUM_ITEMS: Int64 = 3
    var baos = ByteBuffer()

    for (i in 0..3) {
        let header: String = "-----1234\r\nContent-Disposition: form-data; name=\"field\"\r\n\r\n"

        baos.write(header.toArray())
        for (j in 0..1000 + i) {
            baos.write([UInt8(j)])
        }
        baos.write("\r\n".toArray())
    }
    baos.write("-----1234--\r\n".toArray())
    var req1: HttpRequest = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(baos).build()
    req1.headers.add("Content-Type", CONTENT_TYPE)

    var servletRequestContext: ServletRequestContext = ServletRequestContext(req1)
    servletRequestContext.toString()
    let c: Int64 = runTest(NUM_ITEMS, baos.length, servletRequestContext)
    var flag = true
    if (c == 1) {
        flag = false
    }
    @Assert(flag,true)
    println("pass1")
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
        var bytes: Array<UInt8> = Array<UInt8>(16384 + i, repeat: 0)

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
        println("pContentLength="+pContentLength.toString())
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

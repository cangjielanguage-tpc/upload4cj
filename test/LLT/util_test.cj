// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from upload4cj import upload4cj.*
from net import http.*
from std import io.*

@overflowWrapping
main(){
    let CONTENT_TYPE:String = "multipart/form-data; boundary=---1234"

    let NUM_ITEMS: Int64 = 3
    var baos = ByteArrayStream()

    for (i in 0..NUM_ITEMS) {
        let header: String = "-----1234\r\nContent-Disposition: form-data; name=\"field\"\r\n\r\n"

        baos.write(header.toUtf8Array())
        for (j in 0..10+i) {
            baos.write([UInt8(j)])
        }
        baos.write("\r\n".toUtf8Array())
    }
    baos.write("-----1234--\r\n".toUtf8Array())
    var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", baos)
    req1.header.add("Content-Type",CONTENT_TYPE)
    req1.header.add("Content-Length", baos.length.toString())

    var servletRequestContext: ServletRequestContext = ServletRequestContext(req1)
    runTest(NUM_ITEMS, baos.length, servletRequestContext)
    return 0

}

public func runTest(NUM_ITEM: Int64, pContentLength: Int64, request: ServletRequestContext) {

    let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())

    let listener: ProgressListenerImpl = ProgressListenerImpl(pContentLength, 3)
    
    upload.setProgressListener(listener)

    var iter: FileItemIterator = upload.getItemIterator(request)
    
    for (i in 0..3) { 
        let stream: FileItemStream = iter.next()
        var istream: InputStream = stream.openStream()
        var bytes: Array<UInt8> = Array<UInt8>()
        istream.read(bytes)
        var str = String.fromUtf8(bytes)
        println(str)

    }
}
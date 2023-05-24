// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from upload4cj import upload4cj.*
from net import http.*
from std import io.*

main() {
    var aMutableFileItemHeaders: FileItemHeadersImpl = FileItemHeadersImpl()
    aMutableFileItemHeaders.addHeader("Content-Disposition",
        "form-data; name=\"FileItem\"; filename=\"file1.txt\"")


    aMutableFileItemHeaders.addHeader("Content-Type", "text/plain")

    aMutableFileItemHeaders.addHeader("TestHeader", "headerValue1")
    aMutableFileItemHeaders.addHeader("TestHeader", "headerValue2")
    aMutableFileItemHeaders.addHeader("TestHeader", "headerValue3")
    aMutableFileItemHeaders.addHeader("testheader", "headerValue4")

    var headerNameEnumeration: Iterator<String> = aMutableFileItemHeaders.getHeaderNames()
    let a:String = headerNameEnumeration.next().getOrThrow()
    let b:String = headerNameEnumeration.next().getOrThrow()
    let c:String = headerNameEnumeration.next().getOrThrow()

    if (a != "content-disposition") {
        return -1
    }

    if (b != "content-type") {
        return -2
    }

    if (c != "testheader") {
        return -3
    }

    if (headerNameEnumeration.next() != Option<String>.None) {
        return -4
    }

    return 0
}
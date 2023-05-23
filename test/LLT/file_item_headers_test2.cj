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

    let a: Option<String> = aMutableFileItemHeaders.getHeader("Content-Disposition")
    let b: Option<String> = aMutableFileItemHeaders.getHeader("Content-Type")
    let c: Option<String> = aMutableFileItemHeaders.getHeader("content-Type")
    let d: Option<String> = aMutableFileItemHeaders.getHeader("TestHeader")
    let e: Option<String> = aMutableFileItemHeaders.getHeader("DummyHeader")


    if (a.getOrThrow()!= "form-data; name=\"FileItem\"; filename=\"file1.txt\"") {
        return -1
    }

    if (b != "text/plain") {
        return -2
    }

    if (c != "text/plain") {
        return -3
    }

    if (d != "headerValue1") {
        return -4
    }

    if (e != Option<String>.None) {
        return -5
    }

    return 0
}
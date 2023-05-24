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

    let a: Iterator<String> = aMutableFileItemHeaders.getHeaders("Content-Type")
    let b: Iterator<String> = aMutableFileItemHeaders.getHeaders("content-Type")
    let c: Iterator<String> = aMutableFileItemHeaders.getHeaders("TestHeader")
    let d: Iterator<String> = aMutableFileItemHeaders.getHeaders("DummyHeader")


    if (a.next().getOrThrow()!= "text/plain") {
        return -1
    }

    if (a.next()!= Option<String>.None) {
        return -2
    }

    if (b.next().getOrThrow()!= "text/plain") {
        return -3
    }

    if (b.next()!= Option<String>.None) {
        return -4
    }

    if (c.next().getOrThrow()!= "headerValue1") {
        return -5
    }

    if (c.next().getOrThrow()!= "headerValue2") {
        return -6
    }

    if (c.next().getOrThrow()!= "headerValue3") {
        return -7
    }

    if (c.next().getOrThrow()!= "headerValue4") {
        return -8
    }

    if (c.next()!= Option<String>.None) {
        return -9
    }

    if (d.next()!= Option<String>.None) {
        return -10
    }

    return 0
}
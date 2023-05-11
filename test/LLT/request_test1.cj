
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from net import http.*
from std import io.*


main() {
    let sendBody = ByteArrayStream()
    sendBody.write("foo=bar&foo=bar2&bar=baz".toUtf8Array())
    var req = Request(RequestMethod.POST, "http://dummy.faketssssld/", sendBody)
    req.header.add("Content-Type","text/plain")
    var output = ByteArrayStream()
    req.copyTo(output)
    var str = String.fromUtf8(output.readToEnd())
    println(str)
    return 0
}

// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from net import http.*
from std import io.*


main() {
    let sendBody = ByteArrayStream()
    sendBody.write("foo=bar&foo=bar2&bar=baz".toUtf8Array())
    let sizeCon = "foo=bar&foo=bar2&bar=baz".toUtf8Array().size
    var req = HttpRequestBuilder.new().method("POST").url("http://dummy.faketssssld/").body(sendBody).build()
    req.headers.add("Content-Type","text/plain")

    let arrTemp = Array<UInt8>(sizeCon,item:0)
    req.body.read(arrTemp)
    var str = String.fromUtf8(arrTemp)
    println(str)
    return 0
}

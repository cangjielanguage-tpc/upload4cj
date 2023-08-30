
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from net import http.*
from std import io.*
from std import unittest.*
from std import unittest.testmacro.*

main() {
    test1()
    test2()
    test3()
    test4()
}



    func test1(): Unit {
        let sendBody = ByteArrayStream()
        sendBody.write("foo=bar&foo=bar2&bar=baz".toUtf8Array())
        let sizeCon = "foo=bar&foo=bar2&bar=baz".toUtf8Array().size
        var req = HttpRequestBuilder.new().method("POST").url("http://dummy.faketssssld/").body(sendBody).build()
        req.headers.add("Content-Type","text/plain")
        let arrTemp = Array<UInt8>(sizeCon,item:0)
        req.body.read(arrTemp)
        var str = String.fromUtf8(arrTemp)
        @Assert(str,"foo=bar&foo=bar2&bar=baz")
        println("pass1")
     }

    func test2(): Unit {
        let s1: ByteArrayStream = ByteArrayStream()
        s1.write("a=teacher&b=student".toUtf8Array())
        var req1 = HttpRequestBuilder.new().method("POST").url("http://127.0.0.1/").body(s1).build()
        req1.headers.add("Content-Type","application/x-www-form-urlencoded")
        @Assert(req1.form.get("a").getOrThrow(),"teacher")
        println("pass2")
     }

    func test3(): Unit {
        var req2 = HttpRequestBuilder.new().method("GET").url("http://127.0.0.1/?a=teacher&b=student").build()
        req2.headers.add("Content-Type","multipart/form-data")
        @Assert(req2.form.get("b").getOrThrow(),"student")
        println("pass3")
     }

    func test4(): Unit {
        let s2: ByteArrayStream = ByteArrayStream()
        s2.write("a=teacher&b=student&c=director&c=headteacher".toUtf8Array())
        var req3 = HttpRequestBuilder.new().method("POST").url("http://127.0.0.1/").body(s2).build()
        req3.headers.add("Content-Type","application/x-www-form-urlencoded")
        req3.form
        @Assert(req3.form.toEncodeString(),"a=teacher&b=student&c=director&c=headteacher")
        @Assert(req3.form.getAll("c").toString(),"[director, headteacher]")
        println("pass4")
    }


// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import net.http.*
import std.io.*
import std.unittest.*
import std.unittest.testmacro.*

main() {
    test1()
    test2()
    test3()
    test4()
}



    func test1(): Unit {
        let sendBody = ByteBuffer()
        sendBody.write("foo=bar&foo=bar2&bar=baz".toArray())
        let sizeCon = "foo=bar&foo=bar2&bar=baz".toArray().size
        var req = HttpRequestBuilder().method("POST").url("http://dummy.faketssssld/").body(sendBody).build()
        req.headers.add("Content-Type","text/plain")
        let arrTemp = Array<UInt8>(sizeCon,repeat:0)
        req.body.read(arrTemp)
        var str = String.fromUtf8(arrTemp)
        @Assert(str,"foo=bar&foo=bar2&bar=baz")
        println("pass1")
     }

    func test2(): Unit {
        let s1: ByteBuffer = ByteBuffer()
        s1.write("a=teacher&b=student".toArray())
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(s1).build()
        req1.headers.add("Content-Type","application/x-www-form-urlencoded")
        @Assert(req1.form.get("a").getOrThrow(),"teacher")
        println("pass2")
     }

    func test3(): Unit {
        var req2 = HttpRequestBuilder().method("GET").url("http://127.0.0.1/?a=teacher&b=student").build()
        req2.headers.add("Content-Type","multipart/form-data")
        @Assert(req2.form.get("b").getOrThrow(),"student")
        println("pass3")
     }

    func test4(): Unit {
        let s2: ByteBuffer = ByteBuffer()
        s2.write("a=teacher&b=student&c=director&c=headteacher".toArray())
        var req3 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(s2).build()
        req3.headers.add("Content-Type","application/x-www-form-urlencoded")
        req3.form
        @Assert(req3.form.toEncodeString(),"a=teacher&b=student&c=director&c=headteacher")
        @Assert(req3.form.getAll("c").toString(),"[director, headteacher]")
        println("pass4")
    }

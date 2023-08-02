
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from net import http.*
from std import io.*

main(){
    let s1: ByteArrayStream = ByteArrayStream()
    s1.write("a=teacher&b=student".toUtf8Array())
    var req1 = HttpRequestBuilder.new().method("POST").url("http://127.0.0.1/").body(s1).build()
    req1.headers.add("Content-Type","application/x-www-form-urlencoded")
    println("PostFormValue a:${req1.form.get("a").getOrThrow()}")
    var req2 = HttpRequestBuilder.new().method("GET").url("http://127.0.0.1/?a=teacher&b=student").build()
    req2.headers.add("Content-Type","multipart/form-data")
    println("FormValue b:${req2.form.get("b").getOrThrow()}")
    println("------------------------------------------")
    let s2: ByteArrayStream = ByteArrayStream()
    s2.write("a=teacher&b=student&c=director&c=headteacher".toUtf8Array())
    var req3 = HttpRequestBuilder.new().method("POST").url("http://127.0.0.1/").body(s2).build()
    req3.headers.add("Content-Type","application/x-www-form-urlencoded")
    req3.form
    println("Parse the request")
    println("The data of postForm after parsing:${req3.form.toEncodeString()}")
    println("Get all of values which match c:${req3.form.getAll("c")}")
    return 0
}

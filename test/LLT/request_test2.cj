
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from net import http.*
from std import io.*

main(){
    let s1: ByteArrayStream = ByteArrayStream()
    s1.write("a=teacher&b=student".toUtf8Array())
    var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", s1)
    req1.header.add("Content-Type","multipart/form-data")
    println("PostFormValue a:${req1.postFormValue("a")}")
    var req2: Request = Request(RequestMethod.GET, "http://127.0.0.1/?a=teacher&b=student")
    req2.header.add("Content-Type","multipart/form-data")
    println("FormValue b:${req2.formValue("b")}")
    println("------------------------------------------")
    let s2: ByteArrayStream = ByteArrayStream()
    s2.write("a=teacher&b=student&c=director&c=headteacher".toUtf8Array())
    var req3: Request = Request(RequestMethod.POST, "http://127.0.0.1/", s2)
    req3.header.add("Content-Type","multipart/form-data")
    req3.parseForm()
    println("Parse the request")
    println("The data of postForm after parsing:${req3.postForm.toEncodeString()}")
    println("Get all of values which match c:${req3.postForm.getAll("c")}")
    return 0
}

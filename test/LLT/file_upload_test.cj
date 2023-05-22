// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from upload4cj import upload4cj.*
from net import http.*
from std import io.*

main() { 
    // let s = "-----1234\r\n" +
    //                                            "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
    //                                            "Content-Type: text/whatever\r\n" +
    //                                            "\r\n" +
    //                                            "This is the content of the file\n" +
    //                                            "\r\n" +
    //                                            "-----1234\r\n" +
    //                                            "Content-Disposition: form-data; name=\"field\"\r\n" +
    //                                            "\r\n" +
    //                                            "fieldValue\r\n" +
    //                                            "-----1234\r\n" +
    //                                            "Content-Disposition: form-data; name=\"multi\"\r\n" +
    //                                            "\r\n" +
    //                                            "value1\r\n" +
    //                                            "-----1234\r\n" +
    //                                            "Content-Disposition: form-data; name=\"multi\"\r\n" +
    //                                            "\r\n" +
    //                                            "value2\r\n" +
    //                                            "-----1234--\r\n"

    let s = "a=teacher&b=student" 
    var upload: FileUpload = FileUpload()
    var bytes: Array<UInt8> = s.toUtf8Array()
    var output = ByteArrayStream()
    output.write(bytes)

    // request
    var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
    
    upload.parseRequest(ServletRequestContext(req1))

    

    req1.header.add("Content-Type","multipart/form-data")
    println("PostFormValue a:${req1.postFormValue("a")}")



}
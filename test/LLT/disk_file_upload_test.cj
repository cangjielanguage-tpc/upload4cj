// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from upload4cj import upload4cj.*
from std import unittest.*
from std import unittest.testmacro.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

main(){
    let diskFileUploadTest = DiskFileUploadTest()
    diskFileUploadTest.test1()
    diskFileUploadTest.test2()
    return 0
}


@Test
public class DiskFileUploadTest{

    @TestCase
    public func test1(): Unit {
        var expected:Bool = false
        let bytes:Array<UInt8> = "foobar".toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",FileUploadBase.MULTIPART_FORM_DATA)
        let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        try{
            upload.parseRequest(req1)
        }catch(e:FileUploadException){
            expected = true
        }
        @Assert(expected,true)
        println("Pass1")
    }

    @TestCase
    public func test2(): Unit {
        var expected:Bool = false
        let bytes:Array<UInt8> = "foobar".toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type","")
        let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        try{
            upload.parseRequest(req1)
        }catch(e:InvalidContentTypeException){
            expected = true
        }
        @Assert(expected,true)
        println("Pass2")
    }

}

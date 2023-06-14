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
    let sizeTest = SizeTest()
    sizeTest.test1()
    sizeTest.test2()
    sizeTest.test3()
    sizeTest.test4()
    sizeTest.test5()
    return 0
}

@Test
public class SizeTest{

    let CONTENT_TYPE:String = "multipart/form-data; boundary=---1234"

    let text1:String = "-----1234\r\nContent-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\nContent-Type: text/whatever\r\n\r\nThis is the content of the file\n\r\n-----1234--\r\n"

    @TestCase
    public func test1(): Unit {
        let text:String = "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
        "Content-Type: text/whatever\r\n" +
        "\r\n" +
        "This is the content of the file\n" +
        "\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        upload.setFileSizeMax(-1)
        let items:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(items.size,1)
        let item0:FileItem = items.get(0).getOrThrow()
        @Assert("This is the content of the file\n", String.fromUtf8(item0.get().getOrThrow()))
        //===============================================================
        let bytes2:Array<UInt8> = text.toUtf8Array()
        var output2 = ByteArrayStream()
        output2.write(bytes2)
        var req2: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output2)
        req2.header.add("Content-Type",CONTENT_TYPE)
        let upload2:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        upload2.setFileSizeMax(40)
        let items2:ArrayList<FileItem> = upload2.parseRequest(req2).getOrThrow()
        @Assert(items2.size,1)
        let item02:FileItem = items2.get(0).getOrThrow()
        @Assert("This is the content of the file\n", String.fromUtf8(item02.get().getOrThrow()))
        //===============================================================
        let bytes3:Array<UInt8> = text.toUtf8Array()
        var output3 = ByteArrayStream()
        output3.write(bytes3)
        var req3: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output3)
        req3.header.add("Content-Type",CONTENT_TYPE)
        let upload3:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        upload3.setFileSizeMax(30)
        var expected:Bool = false
        try{
            upload3.parseRequest(req3)
        }catch(e:FileSizeLimitExceededException){
            expected = true
        }
        @Assert(expected,true)
        println("Pass1")
    }

    @TestCase
    public func test2(): Unit {
        let text:String = "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
        "Content-Type: text/whatever\r\n" +
        "Content-Length: 10\r\n" +
        "\r\n" +
        "This is the content of the file\n" +
        "\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        upload.setFileSizeMax(-1)
        let items:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(items.size,1)
        let item0:FileItem = items.get(0).getOrThrow()
        @Assert("This is the content of the file\n", String.fromUtf8(item0.get().getOrThrow()))
        //===============================================================
        let bytes2:Array<UInt8> = text.toUtf8Array()
        var output2 = ByteArrayStream()
        output2.write(bytes2)
        var req2: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output2)
        req2.header.add("Content-Type",CONTENT_TYPE)
        let upload2:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        upload2.setFileSizeMax(40)
        let fileSizeMax = upload2.getFileSizeMax()
        @Assert(fileSizeMax,40)
        let items2:ArrayList<FileItem> = upload2.parseRequest(req2).getOrThrow()
        @Assert(items2.size,1)
        let item02:FileItem = items2.get(0).getOrThrow()
        @Assert("This is the content of the file\n", String.fromUtf8(item02.get().getOrThrow()))
        //===============================================================
        let bytes3:Array<UInt8> = text.toUtf8Array()
        var output3 = ByteArrayStream()
        output3.write(bytes3)
        var req3: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output3)
        req3.header.add("Content-Type",CONTENT_TYPE)
        let upload3:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        upload3.setFileSizeMax(5)
        var expected:Bool = false
        try{
            upload3.parseRequest(req3)
        }catch(e:FileSizeLimitExceededException){
            expected = true
        }
        @Assert(expected,true)
        //===============================================================
        let bytes4:Array<UInt8> = text.toUtf8Array()
        var output4 = ByteArrayStream()
        output4.write(bytes4)
        var req4: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output4)
        req4.header.add("Content-Type",CONTENT_TYPE)
        let upload4:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        upload4.setFileSizeMax(15)
        var expected2:Bool = false
        try{
            upload4.parseRequest(req4)
        }catch(e:FileSizeLimitExceededException){
            expected2 = true
        }
        @Assert(expected2,true)
        println("Pass2")
    }

    @TestCase
    public func test3(): Unit {
          let text:String = "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"file1\"; filename=\"foo1.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" +
            "Content-Length: 10\r\n" +
            "\r\n" +
            "This is the content of the file\n" +
            "\r\n" +
            "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"file2\"; filename=\"foo2.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" +
            "\r\n" +
            "This is the content of the file\n" +
            "\r\n" +
            "-----1234--\r\n"
            let bytes:Array<UInt8> = text.toUtf8Array()
            var output = ByteArrayStream()
            output.write(bytes)
            var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
            req1.header.add("Content-Type",CONTENT_TYPE)
            let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
            upload.setFileSizeMax(-1)
            upload.setSizeMax(200)
            let sizeMax = upload.getSizeMax()
            @Assert(sizeMax,200)
            var expected:Bool = false
            try{
                upload.parseRequest(req1)
            }catch(e:SizeLimitExceededException){
                expected = true
            }
            @Assert(expected,true)
            println("Pass3")
    }

    @TestCase
    public func test4(): Unit {
         let text:String = "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"file1\"; filename=\"foo1.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" +
            "Content-Length: 10\r\n" +
            "\r\n" +
            "This is the content of the file\n" +
            "\r\n" +
            "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"file2\"; filename=\"foo2.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" +
            "\r\n" +
            "This is the content of the file\n" +
            "\r\n" +
            "-----1234--\r\n"
            let bytes:Array<UInt8> = text.toUtf8Array()
            var output = ByteArrayStream()
            output.write(bytes)
            var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
            req1.header.add("Content-Type",CONTENT_TYPE)
            req1.header.add("Content-Length","-1")
            let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
            upload.setFileSizeMax(-1)
            upload.setSizeMax(300)
            var expected:Bool = false
            try{
                upload.parseRequest(req1)
            }catch(e:SizeLimitExceededException){
                expected = true
            }
            @Assert(expected,true)
            println("Pass4")
    }

    @TestCase
    public func test5(): Unit {
         let text:String = "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"file1\"; filename=\"foo1.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" +
            "\r\n" +
            "This is the content of the file\n" +
            "\r\n" +
            "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"file2\"; filename=\"foo2.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" +
            "\r\n" +
            "This is the content of the file\n" +
            "\r\n" +
            "-----1234--\r\n"
            let bytes:Array<UInt8> = text.toUtf8Array()
            var output = ByteArrayStream()
            output.write(bytes)
            var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
            req1.header.add("Content-Type",CONTENT_TYPE)
            let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
            upload.setFileCountMax(1)
            let fileCountMax = upload.getFileCountMax()
            @Assert(fileCountMax,1)
            var expected:Bool = false
            try{
                upload.parseRequest(req1)
            }catch(e:FileCountLimitExceededException){
                expected = true
            }
            @Assert(expected,true)
            println("Pass5")
    }
}

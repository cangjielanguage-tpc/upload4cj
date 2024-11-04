// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import upload4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

main(){
    let diskFileUploadTest = DiskFileUploadTest()
    diskFileUploadTest.test1()
    diskFileUploadTest.test2()
    diskFileUploadTest.test3()
    diskFileUploadTest.test4()
    return 0
}


@Test
public class DiskFileUploadTest{

    @TestCase
    public func test1(): Unit {
        var expected:Bool = false
        let bytes:Array<UInt8> = "foobar".toArray()
        var output = ByteBuffer()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type",FileUploadBase.MULTIPART_FORM_DATA)
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
        let bytes:Array<UInt8> = "foobar".toArray()
        var output = ByteBuffer()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type","")
        let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        try{
            upload.parseRequest(req1)
        }catch(e:InvalidContentTypeException){
            expected = true
        }
        @Assert(expected,true)
        println("Pass2")
    }

    @TestCase
    public func test3(): Unit {
        var expected:Bool = false
        let bytes:Array<UInt8> = "foobar".toArray()
        var output = ByteBuffer()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type",FileUploadBase.MULTIPART_FORM_DATA)
        let upload:ServletFileUpload = ServletFileUpload()
        upload.setFileItemFactory(DiskFileItemFactory())
        try{
            upload.parseRequest(req1)
        }catch(e:FileUploadException){
            expected = true
        }
        @Assert(expected,true)
        println("Pass3")
    }

    @TestCase
    public func test4(): Unit {
        let CONTENT_TYPE:String = "multipart/form-data; boundary=---1234"
        let text = "-----1234\r\nContent-Disposition: form-data; name=\"file\";filename=\"foo.tab\"\r\nContent-Type: text/whatever\r\n\r\nThis is the content of the file oo\n\r\n-----1234--\r\n"
        let bytes:Array<UInt8> = text.toArray()
        var output = ByteBuffer()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type",CONTENT_TYPE)
        let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory(0,Option<Directory>.None))
        let items:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let item0:FileItem = items.get(0).getOrThrow()
        let filePath:Path = Path("./uploadtest2temp")
        let file = File(filePath,OpenOption.Create(true))
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        item0.write(file)
        @Assert(items.size,1)
        println("Pass4")
    }

}

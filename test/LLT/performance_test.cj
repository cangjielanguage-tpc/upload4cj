
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*
import std.time.*
import std.unittest.*
import std.unittest.testmacro.*

main(){
    test1()
    test2()
    test3()
    test4()
    test5()
    test6()
    test7()
    test8()
}


     func test1(): Unit {
        let content= "-----1234\r\n" +
                    "Content-Disposition: form-data; name=\"utf8Html\"\r\n" +
                    "\r\n" +
                    "This is the content of the file\n" +
                    "\r\n" +
                    "-----1234--\r\n"
        var body_in=ByteArrayStream()
        body_in.write(content.toArray())
        let fileItemFactory=DiskFileItemFactory()
        let servletFileUpload=ServletFileUpload(fileItemFactory)
        let request = HttpRequestBuilder().method("GET").url("http://www.baidu.com").body(body_in).build()
        request.headers.add("Content-Type","multipart/form-data; boundary=---1234")
        var re=servletFileUpload.parseRequest(request).getOrThrow()
        @Assert(re.size,1)
        @Assert(re[0].isInMemory(),true)
        @Assert(re[0].getSize(),32)
        @Assert(re[0].getString(),"This is the content of the file\n")
        println("pass1")
    }

      func test2(): Unit {
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let content= "-----1234\r\n" +
                    "Content-Disposition: form-data; name=\"utf8Html\"\r\n" +
                    "\r\n" +
                    "This is the content of the file\n" +
                    "\r\n" +
                    "-----1234--\r\n"
        var body_in=ByteArrayStream()
        body_in.write(content.toArray())
        let fileItemFactory=DiskFileItemFactory()
        let servletFileUpload=ServletFileUpload(fileItemFactory)
        let request = HttpRequestBuilder().method("GET").url("http://www.baidu.com").body(body_in).build()
        request.headers.add("Content-Type", CONTENT_TYPE)
        var re=servletFileUpload.parseRequest(request).getOrThrow()
        @Assert(re.size,1)
        @Assert(re[0].isInMemory(),true)
        @Assert(re[0].getSize(),32)
        @Assert(re[0].getString(),"This is the content of the file\n")
        println("pass2")
    }

    func test3(): Unit {
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let str = "\""
        var text = "-----1234\r\n" +
                        "Content-Disposition: form-data; name=${str}test${str}; filename=${str}file1${str}\r\n" +
                        "Content-Type: text/whatever\r\n" +
                        "\r\n" +
                        "This is the content of the file\n" +
                        "\r\n" +
                        "-----1234\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        let req = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let iterator: FileItemIterator = upload.getItemIterator(req)

        let item: FileItemStream = iterator.next()
        let asItem = (item as FileItemStreamImpl).getOrThrow()
        let stream = asItem.openStream()
        var arr = Array<Byte>(100, item: 0)
        let readByteCount = stream.read(arr)
        @Assert(readByteCount, 32)
        println("pass3")
    }


    func test4(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Directory>.None)
        var flag = 0
        dfs.getOutputStream()
        match (dfs.getStoreLocation()) {
            case Some(_) => flag = 1
            case None => flag = 0
        }
        @Assert(flag, 0)
        println("pass4")
    }

  func test5(): Unit {
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let content= "-----1234\r\n" +
                    "Content-Disposition: form-data; name=\"utf8Html\"\r\n" +
                    "\r\n" +
                    "This is the content of the file\n" +
                    "\r\n" +
                    "-----1234--\r\n"
        var body_in=ByteArrayStream()
        body_in.write(content.toArray())
        let servletFileUpload=ServletFileUpload()
        let request = HttpRequestBuilder().method("GET").url("http://www.baidu.com").body(body_in).build()
        request.headers.add("Content-Type", CONTENT_TYPE)
        var re_flag=1
        try{
            servletFileUpload.parseRequest(request)
        }catch(e:Exception){
            re_flag=0
        }
        @Assert(re_flag,0)
        println("pass5")
    }


//用例不应该卡住，应该个数为0
 func test6(): Unit {
        let text ="contentTEXT\r\ntest"
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        let req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        fileItemFactory.setDefaultCharset("UTF-8")
        let upload: FileUpload = FileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(ServletRequestContext(req1)).getOrThrow()
        @Assert(fileItems.size,0)
        println("pass6")
    }

//用例解析出来个数为0
 public func test7(): Unit {
        var flag = 0
        var fu = FileUpload()
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        var text ="-----1234"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        let req = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req.headers.add("Content-Type", CONTENT_TYPE)
        try {
            fu.getItemIterator(ServletRequestContext(req))
        } catch (e: Exception){
            println("e="+e.message)
            flag = 1
        }
        @Assert(flag, 0)
        println("pass7")
    }

 public func test8(): Unit {
        var flag = 0
        var fu = FileUpload()
        var text ="-----1234"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        let req = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        try {
            fu.getItemIterator(ServletRequestContext(req))
        } catch (e: Exception){
            flag = 1
        }
        @Assert(flag, 1)
        println("pass8")
    }

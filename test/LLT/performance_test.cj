

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*
from std import time.*
from std import unittest.*
from std import unittest.testmacro.*

main(){
    testFileUploadBaseIsParseRequest01()
}



 func testFileUploadBaseIsParseRequest01(): Unit {
        let text ="contentTEXT\r\ntest"
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let bytes: Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        fileItemFactory.setDefaultCharset("UTF-8")
        let upload: FileUpload = FileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(ServletRequestContext(req1)).getOrThrow()
        //let fileItem: FileItem = fileItems.get(0).getOrThrow()
        @Assert(fileItems.size,0)
    }


 public func testFileUploadBaseGetItemIterator01(): Unit {
        var flag = 0
        var fu = FileUpload()
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        var text ="-----1234"
        let bytes: Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        let req =Request(RequestMethod.POST, "http://127.0.0.1/",output)
        req.header.add("Content-Type", CONTENT_TYPE)
        try {
            fu.getItemIterator(ServletRequestContext(req))
        } catch (e: Exception){
            println("e="+e.message)
            flag = 1
        }
        @Assert(flag, 0)
    }

 public func testFileUploadBaseGetItemIterator02(): Unit {
        var flag = 0
        var fu = FileUpload()
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        var text ="-----1234"
        let bytes: Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        let req =Request(RequestMethod.POST, "http://127.0.0.1/",output)
        try {
            fu.getItemIterator(ServletRequestContext(req))
        } catch (e: Exception){
            println("e="+e.message)
            flag = 1
        }
        @Assert(flag, 0)
    }

public func test1(n:Int64){
        var totalTime:Int64 = 0
        for(i in 0..n){
            let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
            let text =
            "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
            let bytes: Array<UInt8> = text.toUtf8Array()
            var output = ByteArrayStream()
            output.write(bytes)
            var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
            req1.header.add("Content-Type", CONTENT_TYPE)
            let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
            let s = Time.now()
            let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)
            let e0 = Time.since(s).nanoseconds()
            totalTime += e0
            let vs = mappedParameters.values()
            for(v in vs){
                for(item in v){
                    item.delete()
                }
            }

        }
        let average = Float64(totalTime)/Float64(n)
        println("总时间="+totalTime.toString()+" 总次数="+n.toString()+ " 平均时间="+average.toString())
}



public func test2(n:Int64){
        var totalTime:Int64 = 0
        for(i in 0..n){
            let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
            let text =
            "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
            let bytes: Array<UInt8> = text.toUtf8Array()
            var output = ByteArrayStream()
            output.write(bytes)
            var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
            req1.header.add("Content-Type", CONTENT_TYPE)
            let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
            let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
            let s = Time.now()
            let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
            let e0 = Time.since(s).nanoseconds()
            totalTime += e0
            for(item in fileItems){
                item.delete()
            }
        }
        let average = Float64(totalTime)/Float64(n)
        println("总时间="+totalTime.toString()+" 总次数="+n.toString()+ " 平均时间="+average.toString())
}


public func test3(n:Int64){
        var totalTime:Int64 = 0
        for(i in 0..n){
            let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
            let text =
            "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
            let bytes: Array<UInt8> = text.toUtf8Array()
            var output = ByteArrayStream()
            output.write(bytes)
            var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
            req1.header.add("Content-Type", CONTENT_TYPE)
            let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
            fileItemFactory.setSizeThreshold(1)
            let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
            let s = Time.now()
            let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
            let e0 = Time.since(s).nanoseconds()
            totalTime += e0
            for(item in fileItems){
                item.delete()
            }
        }
        let average = Float64(totalTime)/Float64(n)
        println("总时间="+totalTime.toString()+" 总次数="+n.toString()+ " 平均时间="+average.toString())
}


public func test4(n:Int64){
        var totalTime:Int64 = 0
        for(i in 0..n){
            let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
            let text =
            "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
            let bytes: Array<UInt8> = text.toUtf8Array()
            var output = ByteArrayStream()
            output.write(bytes)
            var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
            req1.header.add("Content-Type", CONTENT_TYPE)
            let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
            fileItemFactory.setSizeThreshold(1)
            let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
            let s = Time.now()
            let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)
            let e0 = Time.since(s).nanoseconds()
            totalTime += e0
            let vs = mappedParameters.values()
            for(v in vs){
                for(item in v){
                    item.delete()
                }
            }

        }
        let average = Float64(totalTime)/Float64(n)
        println("总时间="+totalTime.toString()+" 总次数="+n.toString()+ " 平均时间="+average.toString())
}

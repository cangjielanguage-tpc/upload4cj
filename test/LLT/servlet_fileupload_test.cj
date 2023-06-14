// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from upload4cj import upload4cj.*
from net import http.*
from std import io.*
from std import collection.*
from std import unittest.*
from std import unittest.testmacro.*

main() {
    let servletFileUpload = ServletFileUploadTest()
    servletFileUpload.test1()
    servletFileUpload.test2()
    servletFileUpload.test3()
    servletFileUpload.test4()
    servletFileUpload.test5()
    servletFileUpload.test6()
    servletFileUpload.test7()
    servletFileUpload.test8()
    servletFileUpload.test9()
    servletFileUpload.test10()
    servletFileUpload.test11()
    servletFileUpload.test12()
    return 0
}

@Test
public class ServletFileUploadTest {

    let CONTENT_TYPE:String = "multipart/form-data; boundary=---1234"
    let CONTENT_TYPE2:String = "multipart/form-data; boundary=AaB03x"

    let headerNames:Array<String> = ["SomeHeader", "OtherHeader", "YetAnotherHeader", "WhatAHeader"]
    let headerValues:Array<String> = ["present", "Is there", "Here", "Is That"]

    //这行虽然没有用到 但是不能删 应该是框架问题 删了会报错
    let text1 = "-----1234\r\nContent-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\nContent-Type: text/whatever\r\n\r\nThis is the content of the file\n\r\n-----1234\r\nContent-Disposition: form-data; name=\"field\"\r\n\r\nfieldValue\r\n-----1234\r\nContent-Disposition: form-data; name=\"multi\"\r\n\r\nvalue1\r\n-----1234\r\nContent-Disposition: form-data; name=\"multi\"\r\n\r\nvalue2\r\n-----1234--\r\n"

    @TestCase
    public func test1(): Unit {
        let text = "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
        "Content-Type: text/whatever\r\n" +
        "\r\n" +
        "This is the content of the file\n" +
        "\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"field\"\r\n" +
        "\r\n" +
        "fieldValue\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"multi\"\r\n" +
        "\r\n" +
        "value1\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"multi\"\r\n" +
        "\r\n" +
        "value2\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        let isMulti:Bool = ServletFileUpload.isMultipartContent(req1)
        @Assert(isMulti,true)
        upload.setHeaderEncoding("UTF-8")
        let headerEncoding = upload.getHeaderEncoding()
        @Assert(headerEncoding,"UTF-8")
        upload.setProgressListener(Option<ProgressListener>.None)
        let proListener = upload.getProgressListener()
        var isNull = false
        if(let Some(i) = proListener){
            isNull = false
        }else{
            isNull = true
        }
        @Assert(isNull,true)
        let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)
        @Assert(mappedParameters.contains("file"),true)
        @Assert(mappedParameters.get("file").getOrThrow().size,1)
        @Assert(mappedParameters.contains("field"),true)
        @Assert(mappedParameters.get("field").getOrThrow().size,1)
        @Assert(mappedParameters.contains("multi"),true)
        @Assert(mappedParameters.get("multi").getOrThrow().size,2)
        println("Pass1")
    }

    @TestCase
    public func test2(): Unit {
        let text = "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"utf8Html\"\r\n" +
        "\r\n" +
        "This is the content of the file\n" +
        "\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let fileItemFactory:DiskFileItemFactory = DiskFileItemFactory()
        fileItemFactory.setDefaultCharset("UTF-8")
        let upload:ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let fileItem:FileItem = fileItems.get(0).getOrThrow()
        @Assert(fileItem.getString().contains("content"),true)
        println("Pass2")
    }

    @TestCase
    public func test3(): Unit {
        let text = "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
        "Content-Type: text/whatever\r\n" +
        "\r\n" +
        "This is the content of the file\n" +
        "\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"field\"\r\n" +
        "\r\n" +
        "fieldValue\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"multi\"\r\n" +
        "\r\n" +
        "value1\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"multi\"\r\n" +
        "\r\n" +
        "value2\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let fileItemFactory:DiskFileItemFactory = DiskFileItemFactory()
        let upload:ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,4)
        let file:FileItem = fileItems.get(0).getOrThrow()
        @Assert(file.getFieldName(),"file")
        @Assert(file.isGetFormField(),false)
        @Assert(file.getString(),"This is the content of the file\n")
        @Assert(file.getContentType(),"text/whatever")
        @Assert(file.getName(),"foo.tab")
        let field:FileItem = fileItems.get(1).getOrThrow()
        @Assert(field.getFieldName(),"field")
        @Assert(field.isGetFormField(),true)
        @Assert(field.getString(),"fieldValue")
        let multi0:FileItem = fileItems.get(2).getOrThrow()
        @Assert(multi0.getFieldName(),"multi")
        @Assert(multi0.isGetFormField(),true)
        @Assert(multi0.getString(),"value1")
        let multi1:FileItem = fileItems.get(3).getOrThrow()
        @Assert(multi1.getFieldName(),"multi")
        @Assert(multi1.isGetFormField(),true)
        @Assert(multi1.getString(),"value2")
        println("Pass3")
    }

    @TestCase
    public func test4(): Unit {
        let text = "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"FiLe\"; filename=\"FOO.tab\"\r\n" +
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
        let fileItemFactory:DiskFileItemFactory = DiskFileItemFactory()
        let upload:ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,1)
        let file:FileItem = fileItems.get(0).getOrThrow()
        @Assert(file.getFieldName(),"FiLe")
        @Assert(file.getName(),"FOO.tab")
        println("Pass4")
    }

    @TestCase
    public func test5(): Unit {
        let text = "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"file\"; filename=\"\"\r\n" +
        "\r\n" +
        "\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let fileItemFactory:DiskFileItemFactory = DiskFileItemFactory()
        let upload:ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,1)
        let file:FileItem = fileItems.get(0).getOrThrow()
        @Assert(file.isGetFormField(),false)
        @Assert(file.getString(),"")
        @Assert(file.getName(),"")
        println("Pass5")
    }

    @TestCase
    public func test6(): Unit {
        let text = "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"field1\"\r\n" +
        "\r\n" +
        "fieldValue\r\n" +
        "-----1234\n" + // NOTE \r missing
        "Content-Disposition: form-data; name=\"submitName.x\"\r\n" +
        "\r\n" +
        "42\r\n" +
        "-----1234\n" + // NOTE \r missing
        "Content-Disposition: form-data; name=\"submitName.y\"\r\n" +
        "\r\n" +
        "21\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"field2\"\r\n" +
        "\r\n" +
        "fieldValue2\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let fileItemFactory:DiskFileItemFactory = DiskFileItemFactory()
        let upload:ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,4)
        let field1:FileItem = fileItems.get(0).getOrThrow()
        @Assert(field1.getFieldName(),"field1")
        @Assert(field1.isGetFormField(),true)
        @Assert(field1.getString(),"fieldValue")
        let submitX:FileItem = fileItems.get(1).getOrThrow()
        @Assert(submitX.getFieldName(),"submitName.x")
        @Assert(submitX.isGetFormField(),true)
        @Assert(submitX.getString(),"42")
        let submitY:FileItem = fileItems.get(2).getOrThrow()
        @Assert(submitY.getFieldName(),"submitName.y")
        @Assert(submitY.isGetFormField(),true)
        @Assert(submitY.getString(),"21")
        let field2:FileItem = fileItems.get(3).getOrThrow()
        @Assert(field2.getFieldName(),"field2")
        @Assert(field2.isGetFormField(),true)
        @Assert(field2.getString(),"fieldValue2")
        println("Pass6")
    }

     @TestCase
    public func test7(): Unit {
        let text = "--AaB03x\r\n" +
        "content-disposition: form-data; name=\"field1\"\r\n" +
        "\r\n" +
        "Joe Blow\r\n" +
        "--AaB03x\r\n" +
        "content-disposition: form-data; name=\"pics\"\r\n" +
        "Content-type: multipart/mixed; boundary=BbC04y\r\n" +
        "\r\n" +
        "--BbC04y\r\n" +
        "Content-disposition: attachment; filename=\"file1.txt\"\r\n" +
        "Content-Type: text/plain\r\n" +
        "\r\n" +
        "... contents of file1.txt ...\r\n" +
        "--BbC04y\r\n" +
        "Content-disposition: attachment; filename=\"file2.gif\"\r\n" +
        "Content-type: image/gif\r\n" +
        "Content-Transfer-Encoding: binary\r\n" +
        "\r\n" +
        "...contents of file2.gif...\r\n" +
        "--BbC04y--\r\n" +
        "--AaB03x--"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE2)
        let fileItemFactory:DiskFileItemFactory = DiskFileItemFactory()
        let upload:ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,3)
        let item0:FileItem = fileItems.get(0).getOrThrow()
        @Assert(item0.getFieldName(),"field1")
        @Assert(item0.getName(),"")
        @Assert(String.fromUtf8(item0.get().getOrThrow()),"Joe Blow")
        @Assert(item0.getSize(),8)
        let item1:FileItem = fileItems.get(1).getOrThrow()
        @Assert(item1.getFieldName(),"pics")
        @Assert(item1.getName(),"file1.txt")
        @Assert(String.fromUtf8(item1.get().getOrThrow()),"... contents of file1.txt ...")
        let item2:FileItem = fileItems.get(2).getOrThrow()
        @Assert(item2.getFieldName(),"pics")
        @Assert(item2.getName(),"file2.gif")
        @Assert(String.fromUtf8(item2.get().getOrThrow()),"...contents of file2.gif...")
        println("Pass7")
    }

     @TestCase
    public func test8(): Unit {
        let text = "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
        "Content-Type: text/whatever\r\n" +
        "\r\n" +
        "This is the content of the file\n" +
        "\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; \r\n" +
        "\tname=\"field\"\r\n" +
        "\r\n" +
        "fieldValue\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data;\r\n" +
        "     name=\"multi\"\r\n" +
        "\r\n" +
        "value1\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"multi\"\r\n" +
        "\r\n" +
        "value2\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let fileItemFactory:DiskFileItemFactory = DiskFileItemFactory()
        let upload:ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,4)
        let file:FileItem = fileItems.get(0).getOrThrow()
        @Assert(file.getFieldName(),"file")
        @Assert(file.isGetFormField(),false)
        @Assert(file.getString(),"This is the content of the file\n")
        @Assert(file.getContentType(),"text/whatever")
        @Assert(file.getName(),"foo.tab")
        let field:FileItem = fileItems.get(1).getOrThrow()
        @Assert(field.getFieldName(),"field")
        @Assert(field.isGetFormField(),true)
        @Assert(field.getString(),"fieldValue")
        let multi0:FileItem = fileItems.get(2).getOrThrow()
        @Assert(multi0.getFieldName(),"multi")
        @Assert(multi0.isGetFormField(),true)
        @Assert(multi0.getString(),"value1")
        let multi1:FileItem = fileItems.get(3).getOrThrow()
        @Assert(multi1.getFieldName(),"multi")
        @Assert(multi1.isGetFormField(),true)
        @Assert(multi1.getString(),"value2")
        println("Pass8")
    }

    @TestCase
    public func test9(): Unit {
        let text = "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
        "Content-Type: text/whatever\r\n" +
        headerNames[0] + ": " + headerValues[0] + "\r\n" +
        "\r\n" +
        "This is the content of the file\n" +
        "\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; \r\n" +
        "\tname=\"field\"\r\n" +
        headerNames[1] + ": " + headerValues[1] + "\r\n" +
        "\r\n" +
        "fieldValue\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data;\r\n" +
        "     name=\"multi\"\r\n" +
        headerNames[2] + ": " + headerValues[2] + "\r\n" +
        "\r\n" +
        "value1\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"multi\"\r\n" +
        headerNames[3] + ": " + headerValues[3] + "\r\n" +
        "\r\n" +
        "value2\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let fileItemFactory:DiskFileItemFactory = DiskFileItemFactory()
        let upload:ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,4)
        let file:FileItem = fileItems.get(0).getOrThrow()
        let value0 = assertHeaders(headerNames,headerValues,file,0)
        @Assert(headerValues[0],value0)
        let field:FileItem = fileItems.get(1).getOrThrow()
        let value1 = assertHeaders(headerNames,headerValues,field,1)
        @Assert(headerValues[1],value1)
        let multi0:FileItem = fileItems.get(2).getOrThrow()
        let value2 = assertHeaders(headerNames,headerValues,multi0,2)
        @Assert(headerValues[2],value2)
        let multi1:FileItem = fileItems.get(3).getOrThrow()
        let value3 = assertHeaders(headerNames,headerValues,multi1,3)
        @Assert(headerValues[3],value3)
        println("Pass9")
    }

    func assertHeaders(pHeaderNames:Array<String>,pHeaderValues:Array<String>,pItem:FileItem,pIndex:Int64):String{
        var value:Option<String> = Option<String>.None
        for(i in 0..pHeaderNames.size){
            if(i == pIndex){
                value = pItem.getHeaders().getHeader(pHeaderNames[i])
                break
            }
        }
        return value.getOrThrow()
    }

    @TestCase
    public func test10(): Unit {
        let text = "-----1234\r\n" +
        "content-disposition: form-data; name=\"field1\"\r\n" +
        "\r\n" +
        "Joe Blow\r\n" +
        "-----1234\r\n" +
        "content-disposition: form-data; name=\"pics\"\r\n" +
        "Content-type: multipart/mixed, boundary=---9876\r\n" +
        "\r\n" +
        "-----9876\r\n" +
        "Content-disposition: attachment; filename=\"file1.txt\"\r\n" +
        "Content-Type: text/plain\r\n" +
        "\r\n" +
        "... contents of file1.txt ...\r\n" +
        "-----9876--\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let fileItemFactory:DiskFileItemFactory = DiskFileItemFactory()
        let upload:ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,2)
        let field:FileItem = fileItems.get(0).getOrThrow()
        @Assert(field.getFieldName(),"field1")
        @Assert(field.isGetFormField(),true)
        @Assert(field.getString(),"Joe Blow")
        let file:FileItem = fileItems.get(1).getOrThrow()
        @Assert(file.getFieldName(),"pics")
        @Assert(file.isGetFormField(),false)
        @Assert(file.getString(),"... contents of file1.txt ...")
        @Assert(file.getContentType(),"text/plain")
        @Assert(file.getName(),"file1.txt")
        println("Pass10")
    }

    @TestCase
    public func test11(): Unit {
        let text = "-----1234\r\n" +
        "content-disposition: form-data; name=\"pics\"\r\n" +
        "Content-type: multipart/mixed, boundary=---9876\r\n" +
        "\r\n" +
        "-----9876\r\n" +
        "Content-disposition: attachment; filename=\"file1.txt\"\r\n" +
        "Content-Type: text/plain\r\n" +
        "\r\n" +
        "... contents of file1.txt ...\r\n" +
        "-----9876--\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let fileItemFactory:DiskFileItemFactory = DiskFileItemFactory()
        let upload:ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,1)
        let file:FileItem = fileItems.get(0).getOrThrow()
        @Assert(file.getFieldName(),"pics")
        @Assert(file.isGetFormField(),false)
        @Assert(file.getString(),"... contents of file1.txt ...")
        @Assert(file.getContentType(),"text/plain")
        @Assert(file.getName(),"file1.txt")
        println("Pass11")
    }

    @TestCase
    public func test12(): Unit {
        let text = "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
        "Content-Type: text/whatever\r\n" +
        "\r\n" +
        "This is the content of the file\n" +
        "\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; \r\n" +
        "\tname=\"field\"\r\n" +
        "\r\n" +
        "fieldValue\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data;\r\n" +
        "     name=\"multi\"\r\n" +
        "\r\n" +
        "value1\r\n" +
        "-----1234\r\n" +
        "Content-Disposition: form-data; name=\"multi\"\r\n" +
        "\r\n" +
        "value2\r\n" +
        "-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let fileItemFactory:DiskFileItemFactory = DiskFileItemFactory()
        let upload:ServletFileUpload = ServletFileUpload(fileItemFactory)
        let iterator:FileItemIterator = upload.getItemIterator(req1)
        let b1 = iterator.hasNext()
        iterator.next()
        let b2 = iterator.hasNext()
        iterator.next()
        let b3 = iterator.hasNext()
        iterator.next()
        let b4 = iterator.hasNext()
        iterator.next()
        let b5 = iterator.hasNext()
        @Assert(b1,true)
        @Assert(b2,true)
        @Assert(b3,true)
        @Assert(b4,true)
        @Assert(b5,false)
        println("Pass12")

    }
}


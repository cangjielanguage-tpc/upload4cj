// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import upload4cj.*
import net.http.*
import std.io.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main() {
    let servletFileUpload = ServletFileUploadTest()
    servletFileUpload.test1()
    servletFileUpload.test1A()
    servletFileUpload.test1B()
    servletFileUpload.test1C()
    servletFileUpload.test2()
    servletFileUpload.test3()
    servletFileUpload.test3A()
    servletFileUpload.test3B()
    servletFileUpload.test3C()
    servletFileUpload.test3D()
    servletFileUpload.test4()
    servletFileUpload.test4A()
    servletFileUpload.test5()
    servletFileUpload.test5A()
    servletFileUpload.test6()
    servletFileUpload.test6A()
    servletFileUpload.test6B()
    servletFileUpload.test6C()
    servletFileUpload.test6D()
    servletFileUpload.test7()
    servletFileUpload.test7A()
    servletFileUpload.test7B()
    servletFileUpload.test7C()
    servletFileUpload.test8()
    servletFileUpload.test8A()
    servletFileUpload.test8B()
    servletFileUpload.test8C()
    servletFileUpload.test8D()
    servletFileUpload.test9()
    servletFileUpload.test9A()
    servletFileUpload.test9B()
    servletFileUpload.test9C()
    servletFileUpload.test9D()
    servletFileUpload.test10()
    servletFileUpload.test10A()
    servletFileUpload.test10B()
    servletFileUpload.test11()
    servletFileUpload.test11A()
    servletFileUpload.test12()
    servletFileUpload.test13()
    servletFileUpload.test14()
    servletFileUpload.test15()
    servletFileUpload.test16()
    servletFileUpload.test17()
    return 0
}

@Test
public class ServletFileUploadTest {
    let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
    let CONTENT_TYPE2: String = "multipart/form-data; boundary=AaB03x"

    let headerNames: Array<String> = ["SomeHeader", "OtherHeader", "YetAnotherHeader", "WhatAHeader"]
    let headerValues: Array<String> = ["present", "Is there", "Here", "Is That"]

    //这行虽然没有用到 但是不能删 应该是框架问题 删了会报错
    let text1 = "-----1234\r\nContent-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\nContent-Type: text/whatever\r\n\r\nThis is the content of the file\n\r\n-----1234\r\nContent-Disposition: form-data; name=\"field\"\r\n\r\nfieldValue\r\n-----1234\r\nContent-Disposition: form-data; name=\"multi\"\r\n\r\nvalue1\r\n-----1234\r\nContent-Disposition: form-data; name=\"multi\"\r\n\r\nvalue2\r\n-----1234--\r\n"

    @TestCase
    public func test1(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let isMulti: Bool = ServletFileUpload.isMultipartContent(req1)
        @Assert(isMulti,true)
        println("Pass1")
    }

    @TestCase
    public func test1A(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        upload.setHeaderEncoding("UTF-8")
        let headerEncoding = upload.getHeaderEncoding()
        @Assert(headerEncoding,"UTF-8")
        println("Pass1A")
    }

    @TestCase
    public func test1B(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        upload.setProgressListener(Option<ProgressListener>.None)
        let proListener = upload.getProgressListener()
        var isNull = false
        if (let Some(_) <- proListener) {
            isNull = false
        } else {
            isNull = true
        }
        @Assert(isNull,true)
        println("Pass1B")
    }

    @TestCase
    public func test1C(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)
        @Assert(mappedParameters.contains("file"),true)
        @Assert(mappedParameters.get("file").getOrThrow().size,1)
        @Assert(mappedParameters.contains("field"),true)
        @Assert(mappedParameters.get("field").getOrThrow().size,1)
        @Assert(mappedParameters.contains("multi"),true)
        @Assert(mappedParameters.get("multi").getOrThrow().size,2)
        println("Pass1C")
    }

    @TestCase
    public func test2(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"utf8Html\"\r\n" + "\r\n" +
            "This is the content of the file\n" + "\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        fileItemFactory.setDefaultCharset("UTF-8")
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let fileItem: FileItem = fileItems.get(0).getOrThrow()
        @Assert(fileItem.getString().contains("content"),true)
        println("Pass2")
    }

    @TestCase
    public func test3(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,4)
        println("Pass3")
    }

    @TestCase
    public func test3A(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let file: FileItem = fileItems.get(0).getOrThrow()
        @Assert(file.getFieldName(),"file")
        @Assert(file.isGetFormField(),false)
        @Assert(file.getString(),"This is the content of the file\n")
        @Assert(file.getContentType(),"text/whatever")
        @Assert(file.getName(),"foo.tab")
        println("Pass3A")
    }

    @TestCase
    public func test3B(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let field: FileItem = fileItems.get(1).getOrThrow()
        @Assert(field.getFieldName(),"field")
        @Assert(field.isGetFormField(),true)
        @Assert(field.getString(),"fieldValue")
        println("Pass3B")
    }

    @TestCase
    public func test3C(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let multi0: FileItem = fileItems.get(2).getOrThrow()
        @Assert(multi0.getFieldName(),"multi")
        @Assert(multi0.isGetFormField(),true)
        @Assert(multi0.getString(),"value1")
        println("Pass3C")
    }

    @TestCase
    public func test3D(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let multi1: FileItem = fileItems.get(3).getOrThrow()
        @Assert(multi1.getFieldName(),"multi")
        @Assert(multi1.isGetFormField(),true)
        @Assert(multi1.getString(),"value2")
        println("Pass3D")
    }

    @TestCase
    public func test4(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"FiLe\"; filename=\"FOO.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,1)
        println("Pass4")
    }

    @TestCase
    public func test4A(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"FiLe\"; filename=\"FOO.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let file: FileItem = fileItems.get(0).getOrThrow()
        @Assert(file.getFieldName(),"FiLe")
        @Assert(file.getName(),"FOO.tab")
        println("Pass4A")
    }

    @TestCase
    public func test5(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"\"\r\n" + "\r\n" + "\r\n" +
            "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,1)
        println("Pass5")
    }

    @TestCase
    public func test5A(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"\"\r\n" + "\r\n" + "\r\n" +
            "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let file: FileItem = fileItems.get(0).getOrThrow()
        @Assert(file.isGetFormField(),false)
        @Assert(file.getString(),"")
        @Assert(file.getName(),"")
        println("Pass5A")
    }

    @TestCase
    public func test6(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "fieldValue\r\n" +
            "-----1234\n" + // NOTE \r missing
                "Content-Disposition: form-data; name=\"submitName.x\"\r\n" + "\r\n" + "42\r\n" +
            "-----1234\n" +
                // NOTE \r missing
                "Content-Disposition: form-data; name=\"submitName.y\"\r\n" + "\r\n" + "21\r\n" +
            "-----1234\r\n" + "Content-Disposition: form-data; name=\"field2\"\r\n" + "\r\n" + "fieldValue2\r\n" +
            "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,4)
        println("Pass6")
    }

    @TestCase
    public func test6A(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "fieldValue\r\n" +
            "-----1234\n" + // NOTE \r missing
                "Content-Disposition: form-data; name=\"submitName.x\"\r\n" + "\r\n" + "42\r\n" +
            "-----1234\n" +
                // NOTE \r missing
                "Content-Disposition: form-data; name=\"submitName.y\"\r\n" + "\r\n" + "21\r\n" +
            "-----1234\r\n" + "Content-Disposition: form-data; name=\"field2\"\r\n" + "\r\n" + "fieldValue2\r\n" +
            "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let field1: FileItem = fileItems.get(0).getOrThrow()
        @Assert(field1.getFieldName(),"field1")
        @Assert(field1.isGetFormField(),true)
        @Assert(field1.getString(),"fieldValue")
        println("Pass6A")
    }

    @TestCase
    public func test6B(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "fieldValue\r\n" +
            "-----1234\n" + // NOTE \r missing
                "Content-Disposition: form-data; name=\"submitName.x\"\r\n" + "\r\n" + "42\r\n" +
            "-----1234\n" +
                // NOTE \r missing
                "Content-Disposition: form-data; name=\"submitName.y\"\r\n" + "\r\n" + "21\r\n" +
            "-----1234\r\n" + "Content-Disposition: form-data; name=\"field2\"\r\n" + "\r\n" + "fieldValue2\r\n" +
            "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let submitX: FileItem = fileItems.get(1).getOrThrow()
        @Assert(submitX.getFieldName(),"submitName.x")
        @Assert(submitX.isGetFormField(),true)
        @Assert(submitX.getString(),"42")
        println("Pass6B")
    }

    @TestCase
    public func test6C(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "fieldValue\r\n" +
            "-----1234\n" + // NOTE \r missing
                "Content-Disposition: form-data; name=\"submitName.x\"\r\n" + "\r\n" + "42\r\n" +
            "-----1234\n" +
                // NOTE \r missing
                "Content-Disposition: form-data; name=\"submitName.y\"\r\n" + "\r\n" + "21\r\n" +
            "-----1234\r\n" + "Content-Disposition: form-data; name=\"field2\"\r\n" + "\r\n" + "fieldValue2\r\n" +
            "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let submitY: FileItem = fileItems.get(2).getOrThrow()
        @Assert(submitY.getFieldName(),"submitName.y")
        @Assert(submitY.isGetFormField(),true)
        @Assert(submitY.getString(),"21")
        println("Pass6C")
    }

    @TestCase
    public func test6D(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "fieldValue\r\n" +
            "-----1234\n" + // NOTE \r missing
                "Content-Disposition: form-data; name=\"submitName.x\"\r\n" + "\r\n" + "42\r\n" +
            "-----1234\n" +
                // NOTE \r missing
                "Content-Disposition: form-data; name=\"submitName.y\"\r\n" + "\r\n" + "21\r\n" +
            "-----1234\r\n" + "Content-Disposition: form-data; name=\"field2\"\r\n" + "\r\n" + "fieldValue2\r\n" +
            "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let field2: FileItem = fileItems.get(3).getOrThrow()
        @Assert(field2.getFieldName(),"field2")
        @Assert(field2.isGetFormField(),true)
        @Assert(field2.getString(),"fieldValue2")
        println("Pass6D")
    }

    @TestCase
    public func test7(): Unit {
        let text = "--AaB03x\r\n" + "content-disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "Joe Blow\r\n" +
            "--AaB03x\r\n" + "content-disposition: form-data; name=\"pics\"\r\n" +
            "Content-type: multipart/mixed; boundary=BbC04y\r\n" + "\r\n" + "--BbC04y\r\n" +
            "Content-disposition: attachment; filename=\"file1.txt\"\r\n" + "Content-Type: text/plain\r\n" + "\r\n" +
            "... contents of file1.txt ...\r\n" + "--BbC04y\r\n" +
            "Content-disposition: attachment; filename=\"file2.gif\"\r\n" + "Content-type: image/gif\r\n" +
            "Content-Transfer-Encoding: binary\r\n" + "\r\n" + "...contents of file2.gif...\r\n" + "--BbC04y--\r\n" +
            "--AaB03x--"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE2)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,3)
        println("Pass7")
    }

    @TestCase
    public func test7A(): Unit {
        let text = "--AaB03x\r\n" + "content-disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "Joe Blow\r\n" +
            "--AaB03x\r\n" + "content-disposition: form-data; name=\"pics\"\r\n" +
            "Content-type: multipart/mixed; boundary=BbC04y\r\n" + "\r\n" + "--BbC04y\r\n" +
            "Content-disposition: attachment; filename=\"file1.txt\"\r\n" + "Content-Type: text/plain\r\n" + "\r\n" +
            "... contents of file1.txt ...\r\n" + "--BbC04y\r\n" +
            "Content-disposition: attachment; filename=\"file2.gif\"\r\n" + "Content-type: image/gif\r\n" +
            "Content-Transfer-Encoding: binary\r\n" + "\r\n" + "...contents of file2.gif...\r\n" + "--BbC04y--\r\n" +
            "--AaB03x--"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE2)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let item0: FileItem = fileItems.get(0).getOrThrow()
        @Assert(item0.getFieldName(),"field1")
        @Assert(item0.getName(),"")
        @Assert(String.fromUtf8(item0.get().getOrThrow()),"Joe Blow")
        @Assert(item0.getSize(),8)
        println("Pass7A")
    }

    @TestCase
    public func test7B(): Unit {
        let text = "--AaB03x\r\n" + "content-disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "Joe Blow\r\n" +
            "--AaB03x\r\n" + "content-disposition: form-data; name=\"pics\"\r\n" +
            "Content-type: multipart/mixed; boundary=BbC04y\r\n" + "\r\n" + "--BbC04y\r\n" +
            "Content-disposition: attachment; filename=\"file1.txt\"\r\n" + "Content-Type: text/plain\r\n" + "\r\n" +
            "... contents of file1.txt ...\r\n" + "--BbC04y\r\n" +
            "Content-disposition: attachment; filename=\"file2.gif\"\r\n" + "Content-type: image/gif\r\n" +
            "Content-Transfer-Encoding: binary\r\n" + "\r\n" + "...contents of file2.gif...\r\n" + "--BbC04y--\r\n" +
            "--AaB03x--"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE2)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let item1: FileItem = fileItems.get(1).getOrThrow()
        @Assert(item1.getFieldName(),"pics")
        @Assert(item1.getName(),"file1.txt")
        @Assert(String.fromUtf8(item1.get().getOrThrow()),"... contents of file1.txt ...")
        println("Pass7B")
    }

    @TestCase
    public func test7C(): Unit {
        let text = "--AaB03x\r\n" + "content-disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "Joe Blow\r\n" +
            "--AaB03x\r\n" + "content-disposition: form-data; name=\"pics\"\r\n" +
            "Content-type: multipart/mixed; boundary=BbC04y\r\n" + "\r\n" + "--BbC04y\r\n" +
            "Content-disposition: attachment; filename=\"file1.txt\"\r\n" + "Content-Type: text/plain\r\n" + "\r\n" +
            "... contents of file1.txt ...\r\n" + "--BbC04y\r\n" +
            "Content-disposition: attachment; filename=\"file2.gif\"\r\n" + "Content-type: image/gif\r\n" +
            "Content-Transfer-Encoding: binary\r\n" + "\r\n" + "...contents of file2.gif...\r\n" + "--BbC04y--\r\n" +
            "--AaB03x--"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE2)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let item2: FileItem = fileItems.get(2).getOrThrow()
        @Assert(item2.getFieldName(),"pics")
        @Assert(item2.getName(),"file2.gif")
        @Assert(String.fromUtf8(item2.get().getOrThrow()),"...contents of file2.gif...")
        println("Pass7C")
    }

    @TestCase
    public func test8(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; \r\n" + "\tname=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data;\r\n" + "     name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,4)
        println("Pass8")
    }

    @TestCase
    public func test8A(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; \r\n" + "\tname=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data;\r\n" + "     name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let file: FileItem = fileItems.get(0).getOrThrow()
        @Assert(file.getFieldName(),"file")
        @Assert(file.isGetFormField(),false)
        @Assert(file.getString(),"This is the content of the file\n")
        @Assert(file.getContentType(),"text/whatever")
        @Assert(file.getName(),"foo.tab")
        println("Pass8A")
    }

    @TestCase
    public func test8B(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; \r\n" + "\tname=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data;\r\n" + "     name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let field: FileItem = fileItems.get(1).getOrThrow()
        @Assert(field.getFieldName(),"field")
        @Assert(field.isGetFormField(),true)
        @Assert(field.getString(),"fieldValue")
        println("Pass8B")
    }

    @TestCase
    public func test8C(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; \r\n" + "\tname=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data;\r\n" + "     name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let multi0: FileItem = fileItems.get(2).getOrThrow()
        @Assert(multi0.getFieldName(),"multi")
        @Assert(multi0.isGetFormField(),true)
        @Assert(multi0.getString(),"value1")
        println("Pass8C")
    }

    @TestCase
    public func test8D(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; \r\n" + "\tname=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data;\r\n" + "     name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let multi1: FileItem = fileItems.get(3).getOrThrow()
        @Assert(multi1.getFieldName(),"multi")
        @Assert(multi1.isGetFormField(),true)
        @Assert(multi1.getString(),"value2")
        println("Pass8D")
    }

    @TestCase
    public func test9(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + headerNames[0] + ": " + headerValues[0] + "\r\n" + "\r\n" +
            "This is the content of the file\n" + "\r\n" + "-----1234\r\n" + "Content-Disposition: form-data; \r\n" +
            "\tname=\"field\"\r\n" + headerNames[1] + ": " + headerValues[1] + "\r\n" + "\r\n" + "fieldValue\r\n" +
            "-----1234\r\n" + "Content-Disposition: form-data;\r\n" + "     name=\"multi\"\r\n" + headerNames[2] + ": " +
            headerValues[2] + "\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + headerNames[3] + ": " + headerValues[3] + "\r\n" +
            "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,4)
        println("Pass9")
    }

    @TestCase
    public func test9A(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + headerNames[0] + ": " + headerValues[0] + "\r\n" + "\r\n" +
            "This is the content of the file\n" + "\r\n" + "-----1234\r\n" + "Content-Disposition: form-data; \r\n" +
            "\tname=\"field\"\r\n" + headerNames[1] + ": " + headerValues[1] + "\r\n" + "\r\n" + "fieldValue\r\n" +
            "-----1234\r\n" + "Content-Disposition: form-data;\r\n" + "     name=\"multi\"\r\n" + headerNames[2] + ": " +
            headerValues[2] + "\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + headerNames[3] + ": " + headerValues[3] + "\r\n" +
            "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let file: FileItem = fileItems.get(0).getOrThrow()
        let value0 = assertHeaders(headerNames, file, 0)
        @Assert(headerValues[0],value0)
        println("Pass9A")
    }

    @TestCase
    public func test9B(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + headerNames[0] + ": " + headerValues[0] + "\r\n" + "\r\n" +
            "This is the content of the file\n" + "\r\n" + "-----1234\r\n" + "Content-Disposition: form-data; \r\n" +
            "\tname=\"field\"\r\n" + headerNames[1] + ": " + headerValues[1] + "\r\n" + "\r\n" + "fieldValue\r\n" +
            "-----1234\r\n" + "Content-Disposition: form-data;\r\n" + "     name=\"multi\"\r\n" + headerNames[2] + ": " +
            headerValues[2] + "\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + headerNames[3] + ": " + headerValues[3] + "\r\n" +
            "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let field: FileItem = fileItems.get(1).getOrThrow()
        let value1 = assertHeaders(headerNames, field, 1)
        @Assert(headerValues[1],value1)
        println("Pass9B")
    }

    @TestCase
    public func test9C(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + headerNames[0] + ": " + headerValues[0] + "\r\n" + "\r\n" +
            "This is the content of the file\n" + "\r\n" + "-----1234\r\n" + "Content-Disposition: form-data; \r\n" +
            "\tname=\"field\"\r\n" + headerNames[1] + ": " + headerValues[1] + "\r\n" + "\r\n" + "fieldValue\r\n" +
            "-----1234\r\n" + "Content-Disposition: form-data;\r\n" + "     name=\"multi\"\r\n" + headerNames[2] + ": " +
            headerValues[2] + "\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + headerNames[3] + ": " + headerValues[3] + "\r\n" +
            "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let multi0: FileItem = fileItems.get(2).getOrThrow()
        let value2 = assertHeaders(headerNames, multi0, 2)
        @Assert(headerValues[2],value2)
        println("Pass9C")
    }

    @TestCase
    public func test9D(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + headerNames[0] + ": " + headerValues[0] + "\r\n" + "\r\n" +
            "This is the content of the file\n" + "\r\n" + "-----1234\r\n" + "Content-Disposition: form-data; \r\n" +
            "\tname=\"field\"\r\n" + headerNames[1] + ": " + headerValues[1] + "\r\n" + "\r\n" + "fieldValue\r\n" +
            "-----1234\r\n" + "Content-Disposition: form-data;\r\n" + "     name=\"multi\"\r\n" + headerNames[2] + ": " +
            headerValues[2] + "\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + headerNames[3] + ": " + headerValues[3] + "\r\n" +
            "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let multi1: FileItem = fileItems.get(3).getOrThrow()
        let value3 = assertHeaders(headerNames, multi1, 3)
        @Assert(headerValues[3],value3)
        println("Pass9D")
    }

    func assertHeaders(pHeaderNames: Array<String>, pItem: FileItem, pIndex: Int64): String {
        var value: Option<String> = Option<String>.None
        for (i in 0..pHeaderNames.size) {
            if (i == pIndex) {
                value = pItem.getHeaders().getHeader(pHeaderNames[i])
                break
            }
        }
        return value.getOrThrow()
    }

    @TestCase
    public func test10(): Unit {
        let text = "-----1234\r\n" + "content-disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "Joe Blow\r\n" +
            "-----1234\r\n" + "content-disposition: form-data; name=\"pics\"\r\n" +
            "Content-type: multipart/mixed, boundary=---9876\r\n" + "\r\n" + "-----9876\r\n" +
            "Content-disposition: attachment; filename=\"file1.txt\"\r\n" + "Content-Type: text/plain\r\n" + "\r\n" +
            "... contents of file1.txt ...\r\n" + "-----9876--\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,2)
        println("Pass10")
    }

    @TestCase
    public func test10A(): Unit {
        let text = "-----1234\r\n" + "content-disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "Joe Blow\r\n" +
            "-----1234\r\n" + "content-disposition: form-data; name=\"pics\"\r\n" +
            "Content-type: multipart/mixed, boundary=---9876\r\n" + "\r\n" + "-----9876\r\n" +
            "Content-disposition: attachment; filename=\"file1.txt\"\r\n" + "Content-Type: text/plain\r\n" + "\r\n" +
            "... contents of file1.txt ...\r\n" + "-----9876--\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let field: FileItem = fileItems.get(0).getOrThrow()
        @Assert(field.getFieldName(),"field1")
        @Assert(field.isGetFormField(),true)
        @Assert(field.getString(),"Joe Blow")
        println("Pass10A")
    }

    @TestCase
    public func test10B(): Unit {
        let text = "-----1234\r\n" + "content-disposition: form-data; name=\"field1\"\r\n" + "\r\n" + "Joe Blow\r\n" +
            "-----1234\r\n" + "content-disposition: form-data; name=\"pics\"\r\n" +
            "Content-type: multipart/mixed, boundary=---9876\r\n" + "\r\n" + "-----9876\r\n" +
            "Content-disposition: attachment; filename=\"file1.txt\"\r\n" + "Content-Type: text/plain\r\n" + "\r\n" +
            "... contents of file1.txt ...\r\n" + "-----9876--\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let file: FileItem = fileItems.get(1).getOrThrow()
        @Assert(file.getFieldName(),"pics")
        @Assert(file.isGetFormField(),false)
        @Assert(file.getString(),"... contents of file1.txt ...")
        @Assert(file.getContentType(),"text/plain")
        @Assert(file.getName(),"file1.txt")
        println("Pass10B")
    }

    @TestCase
    public func test11(): Unit {
        let text = "-----1234\r\n" + "content-disposition: form-data; name=\"pics\"\r\n" +
            "Content-type: multipart/mixed, boundary=---9876\r\n" + "\r\n" + "-----9876\r\n" +
            "Content-disposition: attachment; filename=\"file1.txt\"\r\n" + "Content-Type: text/plain\r\n" + "\r\n" +
            "... contents of file1.txt ...\r\n" + "-----9876--\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        @Assert(fileItems.size,1)
        println("Pass11")
    }

    @TestCase
    public func test11A(): Unit {
        let text = "-----1234\r\n" + "content-disposition: form-data; name=\"pics\"\r\n" +
            "Content-type: multipart/mixed, boundary=---9876\r\n" + "\r\n" + "-----9876\r\n" +
            "Content-disposition: attachment; filename=\"file1.txt\"\r\n" + "Content-Type: text/plain\r\n" + "\r\n" +
            "... contents of file1.txt ...\r\n" + "-----9876--\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let file: FileItem = fileItems.get(0).getOrThrow()
        @Assert(file.getFieldName(),"pics")
        @Assert(file.isGetFormField(),false)
        @Assert(file.getString(),"... contents of file1.txt ...")
        @Assert(file.getContentType(),"text/plain")
        @Assert(file.getName(),"file1.txt")
        println("Pass11A")
    }

    @TestCase
    public func test12(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; \r\n" + "\tname=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data;\r\n" + "     name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let iterator: FileItemIterator = upload.getItemIterator(req1)
        let b1 = iterator.hasNext()
        let fis: FileItemStream = iterator.next()
        let contentType = fis.getContentType()
        @Assert(contentType,"text/whatever")
        let name = fis.getName().getOrThrow()
        @Assert(name,"foo.tab")
        let fieldName = fis.getFieldName()
        @Assert(fieldName,"file")
        let isformfield = fis.isFormField()
        @Assert(isformfield,false)
        fis.openStream()
        let headers = fis.getHeaders()
        let value = headers.getHeader("Content-Type").getOrThrow()
        @Assert(value,"text/whatever")
        fis.setHeaders(headers)
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

    @TestCase
    public func test13(): Unit {
        let text = "-----1234\r\n" + "Content-Disposition: form-data; name=\"utf8Html\"\r\n" + "\r\n" +
            "This is the content of the file\n" + "\r\n" + "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)

        let upload: ServletFileUpload = ServletFileUpload()
        var isRight = true
        try {
            upload.parseRequest(req1).getOrThrow()
        } catch (e: NullPointerException) {
            isRight = false
            if (e.toString().contains("No FileItemFactory has been set.")) {
                println("Pass13")
            }
        }
        @Assert(isRight,false)
    }

    @TestCase
    public func test14(): Unit {
        let CONTENT_TYPE_NEW: String = "multipart/form-data; boundary=--------------------------163374768478388063820863"

        let text3 = "----------------------------163374768478388063820863\r\n" +
            "Content-Disposition: form-data; name=\"你cont哈ext好\"; filename=\"密码v是pn稍等.txt\"; filename*=UTF-8''vpn%E5%AF%86%E7%A0%81.txt\r\n" +
            "Content-Type: text/plain\r\n" + "\r\n" + "vpn密码：" + "\r\n" + "angel121376!" + "\r\n" + "weilai2020-3$" +
            "\r\n" + "----------------------------163374768478388063820863--\r\n"

        let bytes: Array<UInt8> = text3.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE_NEW)
        let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)
        @Assert(mappedParameters.size,1)
        @Assert(mappedParameters.get("你cont哈ext好").getOrThrow().get(0).getOrThrow().isGetFormField(),false)
        @Assert(mappedParameters.contains("你cont哈ext好"),true)
        println("Pass14")
    }

    @TestCase
    public func test15(): Unit {
        let CONTENT_TYPE_NEW: String = "multipart/form-data; boundary=--------------------------163374768478388063820863"

        let text4 = "----------------------------163374768478388063820863\r\n" +
            "Content-Disposition: form-data; name=\"f阿斯顿sdfasdasd你name你密码a\"\r\n" + "\r\n" + "vpn密码\r\n" +
            "----------------------------163374768478388063820863\r\n" +
            "Content-Disposition: form-data; name=\"啊大苏打context你密码\"; filename=\"vpn密码1的撒旦.txt\"\r\n" +
            "Content-Type: text/plain\r\n" + "\r\n" + "vpn密码：" + "\r\n" + "angel121376!" + "\r\n" + "weilai2020-3$" +
            "\r\n" + "----------------------------163374768478388063820863\r\n" +
            "Content-Disposition: form-data; name=\"extension\"\r\n" + "\r\n" + "txt\r\n" +
            "----------------------------163374768478388063820863--\r\n"

        let bytes: Array<UInt8> = text4.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE_NEW)
        let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)
        @Assert(mappedParameters.size,3)
        @Assert(mappedParameters.get("啊大苏打context你密码").getOrThrow().get(0).getOrThrow().isGetFormField(),false)
        @Assert(mappedParameters.get("f阿斯顿sdfasdasd你name你密码a").getOrThrow().get(0).getOrThrow().isGetFormField(),true)
        @Assert(mappedParameters.get("extension").getOrThrow().get(0).getOrThrow().isGetFormField(),true)
        @Assert(mappedParameters.contains("f阿斯顿sdfasdasd你name你密码a"),true)
        @Assert(mappedParameters.contains("啊大苏打context你密码"),true)
        @Assert(mappedParameters.contains("extension"),true)
        println("Pass15")
    }

    @TestCase
    public func test16(): Unit {
        let CONTENT_TYPE_NEW: String = "multipart/form-data; boundary=--------------------------163374768478388063820863"

        let text5 = "----------------------------163374768478388063820863\r\n" +
            "Content-Disposition: form-data; name=\"你好context你\"; filename=\"你好vp你n密码密码大苏打萨达萨达是.txt\"; filename*=UTF-8''vpn%E5%AF%86%E7%A0%81.txt\r\n" +
            "Content-Type: text/plain\r\n" + "\r\n" + "vpn密码：123456789" + "\r\n" +
            "----------------------------163374768478388063820863--\r\n"

        let bytes: Array<UInt8> = text5.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE_NEW)
        let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)
        @Assert(mappedParameters.size,1)
        @Assert(mappedParameters.get("你好context你").getOrThrow().get(0).getOrThrow().isGetFormField(),false)
        @Assert(mappedParameters.contains("你好context你"),true)
        println("Pass16")
    }

    @TestCase
    public func test17(): Unit {
        let CONTENT_TYPE_NEW: String = "multipart/form-data; boundary=--------------------------163374768478388063820863"

        let text6 = "----------------------------163374768478388063820863\r\n" +
            "Content-Disposition: form-data; name=\"name密码\"\r\n" + "\r\n" + "vpn密码\r\n" +
            "----------------------------163374768478388063820863--\r\n"

        let bytes: Array<UInt8> = text6.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE_NEW)
        let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)
        @Assert(mappedParameters.size,1)
        @Assert(mappedParameters.get("name密码").getOrThrow().get(0).getOrThrow().isGetFormField(),true)
        @Assert(mappedParameters.contains("name密码"),true)
        println("Pass17")
    }
}

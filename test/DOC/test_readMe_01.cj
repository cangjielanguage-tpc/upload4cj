// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import upload4cj.*
import stdx.net.http.*
import std.io.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
main() {
    let ccc = Test_ReadMe()
    ccc.test_readme_01()
    ccc.test_readme_02()
    0
}

@Test
public class Test_ReadMe{
    let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
	@TestCase
    func test_readme_01 () {
      let text =
            "-----1234\r\n" +
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

        let bytes: Array<UInt8> = text.toArray()
        var output = ByteBuffer()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/")
                   .body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let field: FileItem = fileItems.get(0).getOrThrow()
        @Assert(field.getFieldName(),"field1")
        @Assert(field.isGetFormField(),true)
        @Assert(field.getString(),"Joe Blow")
    }
    @TestCase
    func test_readme_02 () {
      let text =
            "-----1234\r\n" +
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

        let bytes: Array<UInt8> = text.toArray()
        var output = ByteBuffer()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/")
                   .body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)
        @Assert(mappedParameters.contains("file"),true)
        @Assert(mappedParameters.get("file").getOrThrow().size,1)
        @Assert(mappedParameters.contains("field"),true)
        @Assert(mappedParameters.get("field").getOrThrow().size,1)
        @Assert(mappedParameters.contains("multi"),true)
        @Assert(mappedParameters.get("multi").getOrThrow().size,2)
    }

}

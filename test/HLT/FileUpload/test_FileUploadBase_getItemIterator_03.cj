// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/uuid

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

@Test
public class TestFileUploadBase {
    /***
        public init() 
        public func getItemIterator(ctx: RequestContext): FileItemIterator 
        测试场景:  不抛异常分支
    ***/
    @TestCase
    func testFileUploadBaseGetItemIterator03(): Unit {
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let str = "\""
        var text = "-----1234\r\n" +
                        "Content-Disposition: form-data; name=${str}File${str}; filename=${str}foo.tab${str}\r\n" +
                        "Content-Type: text/whatever\r\n" +
                        "\r\n" +
                        "This is the content of the file\n" +
                        "\r\n" +
                        "-----1234\r\n"
        let bytes: Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        var flag = 0
         try {
            upload.getItemIterator(req1)
        } catch (e: Exception){
            flag = 1
        }
        @Assert(flag, 0)
    }
}
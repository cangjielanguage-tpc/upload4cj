// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

@Test
public class TestFileUploadBase {
    /***
        public init() 
        public func parseRequest(ctx: RequestContext): Option<ArrayList<FileItem>> 
        测试场景:  一个item，获取成功
    ***/
    @TestCase
    func testFileUploadBaseIsParseRequest02(): Unit {
        let text =("-----1234\r\n" +
            "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\r\n" +
            "Content-Type: text/whatever\r\n" +
            "\r\n" +
            "This is the content of the file\n" +
            "\r\n" +
            "-----1234--\r\n").toUtf8Array();
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let bytes: Array<UInt8> = text
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        fileItemFactory.setDefaultCharset("UTF-8")
        let upload: FileUpload = FileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(ServletRequestContext(req1)).getOrThrow()
        let fileItem: FileItem = fileItems.get(0).getOrThrow()
        @Assert(fileItem.getString().contains("content"),true)
    }
}
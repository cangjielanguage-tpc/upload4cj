// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj

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
        测试场景:  数据不符合规范，返回空 item
    ***/
    @TestCase
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
        @Assert(fileItems.size,0)
    }
}

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
        public static func isMultipartContent(ctx:RequestContext):Bool
        测试场景:  参数含CONTENT_TYPE分支且开头不为multipart，返回false
    ***/
    @TestCase
    func testFileUploadBaseIsMultipartContent03(): Unit {
        let CONTENT_TYPE: String = "text/form-data; boundary=---1234"
        let req: Request = Request(RequestMethod.POST, "http://127.0.0.1/",ByteArrayStream())
        req.header.add("Content-Type", CONTENT_TYPE)
        let res = FileUpload.isMultipartContent(ServletRequestContext(req))
        @Assert(res, false)
    }
}
// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj

import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

@Test
public class TestFileUploadBase {
    /***
        public static func isMultipartContent(ctx:RequestContext):Bool
        测试场景:  参数含CONTENT_TYPE分支且开头为multipart，返回true
    ***/
    @TestCase
    func testFileUploadBaseIsMultipartContent02(): Unit {
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let req = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(ByteArrayStream()).build()
        req.headers.add("Content-Type", CONTENT_TYPE)
        let res = FileUpload.isMultipartContent(ServletRequestContext(req))
        @Assert(res, true)
    }
}

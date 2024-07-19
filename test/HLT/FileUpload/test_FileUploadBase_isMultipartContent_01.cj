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
        测试场景:  参数不含CONTENT_TYPE分支，返回false
    ***/
    @TestCase
    func testFileUploadBaseIsMultipartContent01(): Unit {
        let req = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(ByteArrayStream()).build()
        //req1.header.add("Content-Type", CONTENT_TYPE)
        let res = FileUpload.isMultipartContent(ServletRequestContext(req))
        @Assert(res, false)
    }
}

// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

@Test
public class TestFileUploadBase {
    /***
        public init()
        public func getItemIterator(ctx: RequestContext): FileItemIterator
        测试场景:  抛异常分支
    ***/
    @TestCase
    func testFileUploadBaseGetItemIterator02(): Unit {
        var flag = 1
        var fu = FileUpload()
        let req = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(ByteBuffer()).build()
        let CONTENT_TYPE: String = "text/form-data; boundary=---1234"
        req.headers.add("Content-Type", CONTENT_TYPE)
        try {
            fu.getItemIterator(ServletRequestContext(req))
        } catch (e: InvalidContentTypeException) {
            flag= 0
        }
        @Assert(flag, 0)
    }
}

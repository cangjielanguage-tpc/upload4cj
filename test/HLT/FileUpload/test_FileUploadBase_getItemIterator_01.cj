// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

@Test
public class TestFileUploadBase {
    /***
        public init()
        public func getItemIterator(ctx: RequestContext): FileItemIterator
        测试场景:  不抛弃异常分支
    ***/
    @TestCase
    func testFileUploadBaseGetItemIterator01(): Unit {
        var flag = 0
        var fu = FileUpload()
        var text ="-----1234"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        let req = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        req.headers.add("Content-Type", CONTENT_TYPE)
        try {
            fu.getItemIterator(ServletRequestContext(req))
        } catch (e: Exception){
            flag = 1
        }
        @Assert(flag, 0)
    }
}

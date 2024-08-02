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
        public func parseRequest(ctx: RequestContext): Option<ArrayList<FileItem>>
        测试场景:  数据不符合规范，返回空 item
    ***/
    @TestCase
    func testFileUploadBaseIsParseRequest01(): Unit {
        let text ="contentTEXT\r\ntest"
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        let req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        fileItemFactory.setDefaultCharset("UTF-8")
        let upload: FileUpload = FileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(ServletRequestContext(req1)).getOrThrow()
        @Assert(fileItems.size,0)
    }
}

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
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteBuffer()
        output.write(bytes)
        let req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
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

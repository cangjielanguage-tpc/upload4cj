// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

@Test
public class TestFileItemIteratorImpl {
    /***
        public override func hasNext (): Bool
        测试场景: 迭代器为空 hasNext为 false
    ***/
    @TestCase
    func testFileItemIteratorImplHasNext01(): Unit {
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        var text = "-----1234ontent-Disposition: form-data; name=\"file\"; filename=\"foo.tab-----1234\r\n-------------"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteBuffer()
        output.write(bytes)
        let req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let iterator: FileItemIterator = upload.getItemIterator(req1)
        let res = iterator.hasNext()
        @Assert(res, false)
    }
}

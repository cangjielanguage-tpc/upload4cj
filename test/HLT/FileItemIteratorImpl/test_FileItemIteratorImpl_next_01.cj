// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

@Test
public class TestFileItemIteratorImpl {
    /***
        public override func next():FileItemStream
        测试场景: 迭代器非空，有一个元素,next一次成功获取信息
    ***/
    @TestCase
    func testFileItemIteratorImplNext01(): Unit {
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let str = "\""
        var text = "-----1234\r\n" +
                        "Content-Disposition: form-data; name=${str}file${str}; filename=${str}foo.tab${str}\r\n" +
                        "Content-Type: text/whatever\r\n" +
                        "\r\n" +
                        "This is the content of the file\n" +
                        "\r\n" +
                        "-----1234--\r\n";
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteBuffer()
        output.write(bytes)
        let req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let iterator: FileItemIterator = upload.getItemIterator(req1)
        let item: FileItemStream = iterator.next()
        let asItem = (item as FileItemStreamImpl).getOrThrow()
        @Assert((asItem.getName()).getOrThrow(), "foo.tab")
    }
}

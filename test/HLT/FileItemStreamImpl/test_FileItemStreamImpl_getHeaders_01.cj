// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

@Test
public class TestFileItemStreamImpl {
    /***
        public override func getHeaders():FileItemHeaders
        测试场景: 正常获取header,有两个header值
    ***/
    @TestCase
    func testFileItemStreamImplGetHeaders01(): Unit {
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let str = "\""
        var text = "-----1234\r\n" +
                        "Content-Disposition: form-data; name=${str}test${str}; filename=${str}file1${str}\r\n" +
                        "Content-Type: text/whatever\r\n" +
                        "\r\n" +
                        "This is the content of the file\n" +
                        "\r\n" +
                        "-----1234\r\n"
        let bytes: Array<UInt8> = text.toArray()
        var output = ByteArrayStream()
        output.write(bytes)
        let req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let iterator: FileItemIterator = upload.getItemIterator(req1)
        let item: FileItemStream = iterator.next()
        let asItem = (item as FileItemStreamImpl).getOrThrow()
        var header = asItem.getHeaders()
        var headerNameEnumeration: Iterator<String> = header.getHeaderNames()
        let a:String = headerNameEnumeration.next().getOrThrow()
        let b:String = headerNameEnumeration.next().getOrThrow()
        @Assert(a, "content-disposition")
        @Assert(b, "content-type")
    }
}

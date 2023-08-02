// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

@Test
public class TestFileItemIteratorImpl {
    /***
        public override func hasNext (): Bool
        测试场景: 迭代器非空，有两个元素, 迭代一次后为true,迭代两次后为false
    ***/
    @TestCase
    func testFileItemIteratorImplHasNext03(): Unit {
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let str = "\""
        var text = "-----1234\r\n" +
                        "Content-Disposition: form-data; name=${str}file${str}; filename=${str}foo.tab${str}\r\n" +
                        "Content-Type: text/whatever\r\n" +
                        "\r\n" +
                        "This is the content of the file\n" +
                        "\r\n" +
                        "-----1234\r\n" +
                        "Content-Disposition: form-data; name=${str}file${str}; filename=${str}foo.tab2${str}\r\n" +
                        "Content-Type: text/whatever\r\n" +
                        "\r\n" +
                        "This is the content of the file\n" +
                        "\r\n" +
                        "-----1234--\r\n"
        let bytes: Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        let req1 = HttpRequestBuilder.new().method("POST").url("http://127.0.0.1/").body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let iterator: FileItemIterator = upload.getItemIterator(req1)
        iterator.next()
        let res = iterator.hasNext()
        @Assert(res, true)
        iterator.next()
        let res2 = iterator.hasNext()
        @Assert(res2, false)
    }
}

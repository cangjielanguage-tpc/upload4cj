// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/uuid

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

@Test
public class TestFileItemStreamImpl {
    /***
        public override func getFieldName():String
        测试场景: FieldName和存入的值相同
    ***/
    @TestCase
    func testFileItemStreamImplGetFieldName01(): Unit {
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        let str = "\""
        var text = "-----1234\r\n" +
                        "Content-Disposition: form-data; name=${str}File${str}; filename=${str}foo.tab${str}\r\n" +
                        "Content-Type: text/whatever\r\n" +
                        "\r\n" +
                        "This is the content of the file\n" +
                        "\r\n" +
                        "-----1234\r\n"
        let bytes: Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let iterator: FileItemIterator = upload.getItemIterator(req1)
        let item: FileItemStream = iterator.next()
        let asItem = (item as FileItemStreamImpl).getOrThrow()
        var res = asItem.getFieldName()
        @Assert(res, "File")
    }
}
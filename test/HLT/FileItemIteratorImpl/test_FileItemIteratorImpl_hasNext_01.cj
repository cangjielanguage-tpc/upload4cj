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
public class TestFileItemIteratorImpl {
    /***
        public override func hasNext (): Bool
        测试场景: 迭代器为空 hasNext为 false
    ***/
    @TestCase
    func testFileItemIteratorImplHasNext01(): Unit {
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        var text = "-----1234ontent-Disposition: form-data; name=\"file\"; filename=\"foo.tab-----1234\r\n-------------"
        let bytes: Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let iterator: FileItemIterator = upload.getItemIterator(req1)
        let res = iterator.hasNext()
        @Assert(res, false)
    }
}
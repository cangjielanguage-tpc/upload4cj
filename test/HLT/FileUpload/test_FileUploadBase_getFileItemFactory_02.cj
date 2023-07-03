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
public class TestFileUploadBase {
    /***
        public init(fileItemFactory: Option<FileItemFactory>) 
        public override func getFileItemFactory(): Option<FileItemFactory>
        测试场景:  带参数fileItemFactory构造，返回非None
    ***/
    @TestCase
    func testFileUploadBaseGetFileItemFactory02(): Unit {
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        var fu = FileUpload(fileItemFactory)
        var flag = 1
        match (fu.getFileItemFactory()) {
            case Some(v) => flag = 0
            case None => flag = 1
        }

        @Assert(flag, 0)
    }
}
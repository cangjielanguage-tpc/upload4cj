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
public class TestDiskFileItem {
    /***
        public init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int64, repository: Option<Directory>)
        public override func getContentType(): String
        测试场景: 测试场景: 返回传入的 contenttype 值
    ***/
    @TestCase
    func testDiskFileItemGetContentType01(): Unit {
        let dfs = DiskFileItem("a1" , "diskfile" , false, "testfile" , 129 , Option<Directory>.None)
        let res = dfs.getContentType()
        @Assert(res, "diskfile")
    }
}
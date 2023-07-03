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
        public func isGetFormField(): Bool
        测试场景: 返回初始化的 isFormField
    ***/
    @TestCase
    func testDiskFileItemIsGetFormField01(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Directory>.None)
        var res = dfs.isGetFormField()
        @Assert(res, false)
        let dfs2 = DiskFileItem("a1" , "text/html; charset=utf16" , true, "testfile" , 129 , Option<Directory>.None)
        res = dfs2.isGetFormField()
        @Assert(res, true)
    }
}
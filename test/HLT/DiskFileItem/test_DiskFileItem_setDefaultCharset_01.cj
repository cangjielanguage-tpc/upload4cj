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
        public func setDefaultCharset(charset:String):Unit
        测试场景: 返回新设置的 Charset
    ***/
    @TestCase
    func testDiskFileItemIsSetDefaultCharset01(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Directory>.None)
        dfs.setDefaultCharset("OTHERS")
        var res = dfs.getDefaultCharset()
        @Assert(res, "OTHERS")
    }
}
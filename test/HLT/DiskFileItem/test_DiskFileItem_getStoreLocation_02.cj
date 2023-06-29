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
        public func getStoreLocation(): Option<File> 
        测试场景: dfos非空repository为空，返回None
    ***/
    @TestCase
    func testDiskFileItemIsGetStoreLocation02(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Directory>.None)
        var flag = 0
        dfs.getOutputStream()
        match (dfs.getStoreLocation()) {
            case Some(v) => flag = 1
            case None => flag = 0
        }
        @Assert(flag, 0)
    }
}
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
        public init() 
        public func setHeaderEncoding(encoding:Option<String>):Unit
        测试场景:  set后获取到set的值
    ***/
    @TestCase
    func testFileUploadBaseSetHeaderEncoding01(): Unit {
        var fu = FileUpload()
        fu.setHeaderEncoding("test")
        var flag = 1
        match (fu.getHeaderEncoding()) {
            case Some(v) => flag = 0
            case None => flag = 1
        }
        @Assert(flag, 0)
    }
}
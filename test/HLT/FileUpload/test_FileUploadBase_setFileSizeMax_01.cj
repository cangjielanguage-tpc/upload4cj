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
        public func setFileSizeMax(parafileSizeMax:Int64):Unit
        测试场景:  set后获取到set的值
    ***/
    @TestCase
    func testFileUploadBaseSetFileSizeMax01(): Unit {
        var fu = FileUpload()
        @Assert(fu.getFileSizeMax(), -1)
        fu.setFileSizeMax(8000)
        @Assert(fu.getFileSizeMax(), 8000)
    }
}
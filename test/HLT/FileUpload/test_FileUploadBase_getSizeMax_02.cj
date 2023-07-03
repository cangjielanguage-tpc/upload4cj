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
        public func getSizeMax():Int64
        测试场景:  造获取到的值为set的值
    ***/
    @TestCase
    func testFileUploadBaseGetSizeMax02(): Unit {
        var fu = FileUpload()
        fu.setSizeMax(10123)
        var res = fu.getSizeMax()
        @Assert(res, 10123)
    }
}
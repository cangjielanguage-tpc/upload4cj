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
        public func getFileCountMax():Int64
        测试场景:  空构造获取到的值为-1
    ***/
    @TestCase
    func testFileUploadBaseGetFileCountMax01(): Unit {
        var fu = FileUpload()
        var res = fu.getFileCountMax()
        @Assert(res, -1)
    }
}
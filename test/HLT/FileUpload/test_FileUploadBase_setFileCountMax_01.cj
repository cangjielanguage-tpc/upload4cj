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
        public func setFileCountMax(tempFileCountMax:Int64):Unit
        测试场景:  set值成功
    ***/
    @TestCase
    func testFileUploadBaseSetFileCountMax01(): Unit {
        var fu = FileUpload()
        var res = fu.setFileCountMax(1234856)
        @Assert(fu.getFileCountMax(), 1234856)
    }
}
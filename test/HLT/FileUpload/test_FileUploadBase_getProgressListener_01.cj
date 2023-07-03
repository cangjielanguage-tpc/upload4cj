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
        public func getProgressListener():Option<ProgressListener>
        测试场景:  空构造，默认返回None
    ***/
    @TestCase
    func testFileUploadBaseGetFileCountMax01(): Unit {
        var fu = FileUpload()
        var flag = 1
        match (fu.getProgressListener()) {
            case Some(v) => flag = 1
            case None => flag = 0
        }
        @Assert(flag, 0)
    }
}
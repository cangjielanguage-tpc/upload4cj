// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

@Test
public class TestFileUploadBase {
    /***
        public init() 
        public func getHeaderEncoding():Option<String>
        测试场景:  空构造获取到的值为-1
    ***/
    @TestCase
    func testFileUploadBaseGetHeaderEncoding01(): Unit {
        var fu = FileUpload()
        var flag = 1
        match (fu.getHeaderEncoding()) {
            case Some(v) => flag = 1
            case None => flag = 0
        }
        @Assert(flag, 0)
    }
}
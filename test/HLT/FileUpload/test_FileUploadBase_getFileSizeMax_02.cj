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
        public func getFileSizeMax():Int64
        测试场景:  造获取到的值为set的值
    ***/
    @TestCase
    func testFileUploadBaseGetFileSizeMax02(): Unit {
        var fu = FileUpload()
        fu.setFileSizeMax(10123)
        var res = fu.getFileSizeMax()
        @Assert(res, 10123)
    }
}
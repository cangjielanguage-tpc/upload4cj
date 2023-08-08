// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj

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
            case Some(_) => flag = 0
            case None => flag = 1
        }
        @Assert(flag, 0)
    }
}

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
public class TestDiskFileItemFactory {
    /***
        public init() 
        public func setDefaultCharset(pCharset: String): Unit
        测试场景: 空构造，设置的Repository成功
    ***/
    @TestCase
    func testDiskFileItemFactorySetDefaultCharset01(): Unit {
        let dff = DiskFileItemFactory()
        dff.setDefaultCharset("others")
        @Assert(dff.getDefaultCharset(), "others")
    }
}
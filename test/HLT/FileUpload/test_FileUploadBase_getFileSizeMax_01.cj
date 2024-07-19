// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj

import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

@Test
public class TestFileUploadBase {
    /***
        public init()
        public func getFileSizeMax():Int64
        测试场景:  空构造获取到的值为-1
    ***/
    @TestCase
    func testFileUploadBaseGetFileSizeMax01(): Unit {
        var fu = FileUpload()
        var res = fu.getFileSizeMax()
        @Assert(res, -1)
    }
}

// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

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

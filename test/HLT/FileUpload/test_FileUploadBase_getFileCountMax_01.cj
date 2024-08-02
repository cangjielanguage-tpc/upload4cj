// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

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

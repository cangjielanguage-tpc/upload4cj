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
        public func setSizeMax(parafileSizeMax:Int64):Unit
        测试场景:  set后获取到set的值
    ***/
    @TestCase
    func testFileUploadBaseSetSizeMax01(): Unit {
        var fu = FileUpload()
        @Assert(fu.getSizeMax(), -1)
        fu.setSizeMax(8000)
        @Assert(fu.getSizeMax(), 8000)
    }
}

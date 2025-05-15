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
        public func setFileSizeMax(parafileSizeMax:Int64):Unit
        测试场景:  set后获取到set的值
    ***/
    @TestCase
    func testFileUploadBaseSetFileSizeMax01(): Unit {
        var fu = FileUpload()
        @Assert(fu.getFileSizeMax(), -1)
        fu.setFileSizeMax(8000)
        @Assert(fu.getFileSizeMax(), 8000)
    }
}

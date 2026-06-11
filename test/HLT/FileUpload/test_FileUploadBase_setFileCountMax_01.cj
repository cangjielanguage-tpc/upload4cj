// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import cangjie_tpc::upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

@Test
public class TestFileUploadBase {
    /***
        public init()
        public func setFileCountMax(tempFileCountMax:Int64):Unit
        测试场景:  set值成功
    ***/
    @TestCase
    func testFileUploadBaseSetFileCountMax01(): Unit {
        var fu = FileUpload()
        fu.setFileCountMax(1234856)
        @Assert(fu.getFileCountMax(), 1234856)
    }
}

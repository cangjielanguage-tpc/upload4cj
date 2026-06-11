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

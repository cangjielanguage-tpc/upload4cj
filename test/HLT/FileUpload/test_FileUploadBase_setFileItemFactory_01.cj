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
        public override func setFileItemFactory(factory: Option<FileItemFactory>)
        测试场景:  空构造返回None，set后非None
    ***/
    @TestCase
    func testFileUploadBaseSetFileItemFactory02(): Unit {
        var fu = FileUpload()
        var flag = 1
        match (fu.getFileItemFactory()) {
            case Some(_) => flag = 1
            case None => flag = 0
        }
        @Assert(flag, 0)

        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        fu.setFileItemFactory(fileItemFactory)
        match (fu.getFileItemFactory()) {
            case Some(_) => flag = 0
            case None => flag = 1
        }
        @Assert(flag, 0)
    }
}

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
        public init(fileItemFactory: Option<FileItemFactory>)
        public override func getFileItemFactory(): Option<FileItemFactory>
        测试场景:  带参数fileItemFactory构造，返回非None
    ***/
    @TestCase
    func testFileUploadBaseGetFileItemFactory02(): Unit {
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        var fu = FileUpload(fileItemFactory)
        var flag = 1
        match (fu.getFileItemFactory()) {
            case Some(_) => flag = 0
            case None => flag = 1
        }

        @Assert(flag, 0)
    }
}

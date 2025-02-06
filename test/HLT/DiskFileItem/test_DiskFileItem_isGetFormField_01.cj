// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

@Test
public class TestDiskFileItem {
    /***
        public init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int64, repository: Option<Path>)
        public func isGetFormField(): Bool
        测试场景: 返回初始化的 isFormField
    ***/
    @TestCase
    func testDiskFileItemIsGetFormField01(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Path>.None)
        var res = dfs.isGetFormField()
        @Assert(res, false)
        let dfs2 = DiskFileItem("a1" , "text/html; charset=utf16" , true, "testfile" , 129 , Option<Path>.None)
        res = dfs2.isGetFormField()
        @Assert(res, true)
    }
}

// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import cangjie_tpc::upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

@Test
public class TestDiskFileItemFactory {
    /***
        public init()
        public override func createItem(fieldName: String, contentType: String, isFormField: Bool, fileName: String):FileItem
        测试场景: 构造对应的DiskFileItem
    ***/
    @TestCase
    func testDiskFileItemFactory02(): Unit {
        let dff = DiskFileItemFactory()
        let dfs: DiskFileItem = (dff.createItem("name1" , "text/html; charset=utf16" , false, "testfile") as DiskFileItem).getOrThrow()
        @Assert(dfs.getCharSet(), "utf16")
        @Assert(dfs.getFieldName(), "name1")
        @Assert(dfs.isGetFormField(), false)
    }
}

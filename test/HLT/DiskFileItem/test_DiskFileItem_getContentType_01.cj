// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import cangjie_tpc::upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

@Test
public class TestDiskFileItem {
    /***
        public init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int64, repository: Option<Path>)
        public override func getContentType(): String
        测试场景: 测试场景: 返回传入的 contenttype 值
    ***/
    @TestCase
    func testDiskFileItemGetContentType01(): Unit {
        let dfs = DiskFileItem("a1" , "diskfile" , false, "testfile" , 129 , Option<Path>.None)
        let res = dfs.getContentType()
        @Assert(res, "diskfile")
    }
}

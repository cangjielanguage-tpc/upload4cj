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
        public init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int64, repository: Option<Directory>)
        public func getStoreLocation(): Option<File>
        测试场景: dfos和repository为空，返回None
    ***/
    @TestCase
    func testDiskFileItemIsGetStoreLocation01(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Directory>.None)
        var flag = 0
        match (dfs.getStoreLocation()) {
            case Some(_) => flag = 1
            case None => flag = 0
        }
        @Assert(flag, 0)
    }
}

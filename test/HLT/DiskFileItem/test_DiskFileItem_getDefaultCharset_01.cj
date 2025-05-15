// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

@Test
public class TestDiskFileItem {
    /***
        public init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int64, repository: Option<Path>)
        public func getDefaultCharset():String
        测试场景: 默认Charset是UTF-8
    ***/
    @TestCase
    func testDiskFileItemIsGetDefaultCharset01(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Path>.None)
        var res = dfs.getDefaultCharset()
        @Assert(res, "UTF-8")
    }
}

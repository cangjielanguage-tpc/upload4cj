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
        public override func getHeaders(): FileItemHeaders
        测试场景: 返回默认空 FileItemHeadersImpl, 迭代取值返回空
    ***/
    @TestCase
    func testDiskFileItemIsSetFormField01(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Path>.None)
        var headers = dfs.getHeaders()
        var headerName: Iterator<String> = headers.getHeaderNames()
        var flag = 1
        try {
            headerName.next().getOrThrow()
        } catch (e: NoneValueException) {
            flag = 0
        }
        @Assert(flag, 0)
    }
}

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
        public override func get(): Option<Array<UInt8>>
        测试场景: 测试场景: dfos 为空，报空异常
    ***/
    @TestCase
    func testDiskFileItemGet01(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Path>.None)
        var flag= 1
        try {
            dfs.get()
        } catch (e: NoneValueException) {
            flag = 0
        }
        @Assert(flag, 0)
    }
}

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
        public override func get(): Option<Array<UInt8>>
        测试场景: 测试场景: dfos 非空，获取到存入的值
    ***/
    @TestCase
    func testDiskFileItemGet02(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Path>.None)
        var flag= 0
        try {
            let out = dfs.getOutputStream()
            out.write([45,87,45,88])
            var arr = dfs.get().getOrThrow()
            @Assert(arr.toString(), "[45, 87, 45, 88]")
        } catch (e: NoneValueException) {
            flag = 1
        }
        @Assert(flag, 0)
    }
}

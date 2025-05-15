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
        测试场景: getInputStream缓存后再写入，返回缓存的值
    ***/
    @TestCase
    func testDiskFileItemGet03(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Path>.None)
        var flag= 0
        try {
            let out = dfs.getOutputStream()
            out.write([45,87,45,88])
            dfs.getInputStream()
            out.write([5,7,5,8])
            var arr = dfs.get().getOrThrow()
            @Assert(arr.toString(), "[45, 87, 45, 88]")
        } catch (e: NoneValueException) {
            flag = 1
        }
        @Assert(flag, 0)
    }
}

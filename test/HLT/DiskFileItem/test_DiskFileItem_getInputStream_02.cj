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
        public override func getInputStream(): InputStream
        测试场景: 缓存有值，且为存入的值
    ***/
    @TestCase
    func testDiskFileItemGetInputStream01(): Unit {
        let dfs = DiskFileItem("a1" , "diskfile" , false, "testfile" , 129 , Option<Path>.None)
        var flag = 0
        try {
            let out = dfs.getOutputStream()
            out.write([45,87,45,88])
            let res = dfs.getInputStream().getOrThrow()
            let arr:Array<UInt8> = [0,0,0,0]
            res.read(arr)
            @Assert(arr.toString(), "[45, 87, 45, 88]")
        } catch (e: NoneValueException) {
            flag = 1
        }
        @Assert(flag, 0)
    }
}

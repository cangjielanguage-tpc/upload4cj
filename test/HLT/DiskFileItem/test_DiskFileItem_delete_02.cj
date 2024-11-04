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
        public override func delete()
        测试场景: isOutputFile 为 true 正常 deleie
    ***/
    @TestCase
    func testDiskFileItemDelete02(): Unit {
        let dirPath:Path = Path("./dirfactory")
        if(!exists(dirPath)) {
            Directory.create(dirPath)
        }
        var dir = Directory(dirPath)
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 ,dir)
        var flag= 0
        try {
            dfs.delete()
        } catch (e: NoneValueException) {
            flag = 1
        }
        @Assert(flag, 0)
    }
}

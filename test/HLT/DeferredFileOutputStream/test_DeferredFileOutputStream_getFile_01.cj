// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import cangjie_tpc::upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

@Test
public class TestDeferredFileOutputStream {
    /***
        public init(threshold: Int64, tempFile: Option<File>,repository:Option<Path>)
        public func getFile(): File
        测试场景: 返回的File等于构造传入的File
    ***/
    @TestCase
    func testDeferredFileOutputStreamGetFile01(): Unit {
        if(!exists("./testtemp1")){
            File.create("./testtemp1")
        }
        let file = File(Path("./testtemp1"),OpenMode.ReadWrite)
        var flag = 0
        let dirPath:Path = Path("./dirfactory")
        if(!exists(dirPath)) {
            Directory.create(dirPath)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(16, file,dirPath)
         dfos.write(("01234567890123456789").toArray())
        var res: File = dfos.getFile().getOrThrow()
        if (!refEq(file, res)) {
            flag = 1
        }
        @Assert(flag, 0)
    }
}

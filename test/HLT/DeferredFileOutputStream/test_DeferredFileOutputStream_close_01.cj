// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

@Test
public class TestDeferredFileOutputStream {
    /***
        public init(threshold: Int64, tempFile: Option<File>,repository:Option<Path>)
        public func close(): Unit
        测试场景: 正常close,无分支，无异常
    ***/
    @TestCase
    func testDeferredFileOutputStreamClose01(): Unit {
        if(!exists("./testtemp1")){
            File.create("./testtemp1")
        }
        let file = File(Path("./testtemp1"),OpenMode.Read)
        var flag = 0
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(16, file, Option<Path>.None)
        try {
            dfos.close()
        } catch (e: Exception) {
            flag = 1
        }
        @Assert(flag, 0)
    }
}

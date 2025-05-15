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
        public func getData(): Option<Array<UInt8>>
        测试场景: getData返回值非None
    ***/
    @TestCase
    func testDeferredFileOutputStreamGetData01(): Unit {
        if(!exists("./testtemp1")){
            File.create("./testtemp1")
        }
        let file = File(Path("./testtemp1"),OpenMode.Read)
        var flag = 0
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(16, file, Option<Path>.None)
        var res = dfos.getData()
        if (let None <- res) {
            flag = 1
        }
        @Assert(flag, 0)
    }
}

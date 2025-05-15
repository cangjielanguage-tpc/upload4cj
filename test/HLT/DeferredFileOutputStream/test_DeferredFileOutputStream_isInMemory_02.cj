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
        public func isInMemory(): Bool
        测试场景: 测试场景: threshold < written(初始为0) 返回 false
    ***/
    @TestCase
    func testDeferredFileOutputStreamIsInMemory02(): Unit {
        if(!exists("./testtemp1")){
            File.create("./testtemp1")
        }
        let file = File(Path("./testtemp1"),OpenMode.Read)
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(-10, file,Option<Path>.None)
        var res: Bool = dfos.isInMemory()
        @Assert(res, false)
    }
}

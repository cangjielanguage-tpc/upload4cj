// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

@Test
public class TestDeferredFileOutputStream {
    /***
        public init(threshold: Int64, tempFile: Option<File>,repository:Option<Directory>)
        public func isInMemory(): Bool
        测试场景: 测试场景: threshold = written(初始为0) 返回 false
    ***/
    @TestCase
    func testDeferredFileOutputStreamIsInMemory03(): Unit {
        if(!File.exists("./testtemp1")){
            File.create("./testtemp1")
        }
        let file = File(Path("./testtemp1"),OpenOption.Open(false, false))
        var flag = 0
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(0, file,Option<Directory>.None)
        var res: Bool = dfos.isInMemory()
        @Assert(res, true)
    }
}
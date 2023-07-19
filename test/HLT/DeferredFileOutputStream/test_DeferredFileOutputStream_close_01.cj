// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

@Test
public class TestDeferredFileOutputStream {
    /***
        public init(threshold: Int64, tempFile: Option<File>,repository:Option<Directory>)
        public func close(): Unit
        测试场景: 正常close,无分支，无异常
    ***/
    @TestCase
    func testDeferredFileOutputStreamClose01(): Unit {
        if(!File.exists("./testtemp1")){
            File.create("./testtemp1")
        }
        let file = File(Path("./testtemp1"),OpenOption.Open(false, false))
        var flag = 0
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(16, file, Option<Directory>.None)
        try {
            dfos.close()
        } catch (e: Exception) {
            flag = 1
        }
        @Assert(flag, 0)
    }
}

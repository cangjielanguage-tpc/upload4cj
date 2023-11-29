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
        public func getFile(): File
        测试场景: 返回的File等于构造传入的File
    ***/
    @TestCase
    func testDeferredFileOutputStreamGetFile01(): Unit {
        if(!File.exists("./testtemp1")){
            File.create("./testtemp1")
        }
        let file = File(Path("./testtemp1"),OpenOption.Open(true, true))
        var flag = 0
        let dirPath:Path = Path("./dirfactory")
        if(!Directory.exists(dirPath)) {
            Directory.create(dirPath)
        }
        var dir = Directory(dirPath)
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(16, file,dir)
         dfos.write(("01234567890123456789").toArray())
        var res: File = dfos.getFile().getOrThrow()
        if (!refEq(file, res)) {
            flag = 1
        }
        @Assert(flag, 0)
    }
}

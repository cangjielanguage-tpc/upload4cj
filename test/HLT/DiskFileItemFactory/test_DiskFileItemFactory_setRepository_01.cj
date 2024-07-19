// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj

import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

@Test
public class TestDiskFileItemFactory {
    /***
        public init()
        public func setRepository(tempRepository:Option<Directory>):Unit
        测试场景: 空构造，设置的Repository成功
    ***/
    @TestCase
    func testDiskFileItemFactory02(): Unit {
        let dff = DiskFileItemFactory()

        let dirPath:Path = Path("./dirfactory2")
        if(!Directory.exists(dirPath)) {
            Directory.create(dirPath)
        }
        var dir = Directory(dirPath)

        dff.setRepository(dir)

        let info = dff.getRepository().getOrThrow().info
        let res = info.path.toCanonical().toString()
        let origin = dirPath.toCanonical().toString()
        @Assert(res, origin)
    }
}

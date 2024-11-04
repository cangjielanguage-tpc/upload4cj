// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

@Test
public class TestDiskFileItemFactory {
    /***
        public init(sizeThreshold: Int64, repository: Option<Directory>)
        public func getRepository():Option<Directory>
        测试场景: 非空构造，返回默认构造的repository
    ***/
    @TestCase
    func testDiskFileItemFactory02(): Unit {
        let dirPath:Path = Path("./dirfactory")
        if(!exists(dirPath)) {
            Directory.create(dirPath)
        }
        var dir = Directory(dirPath)
        let dff = DiskFileItemFactory(128, dir)
        let info = dff.getRepository().getOrThrow().info
        let res =  canonicalize(info.path).toString()
        let origin = canonicalize(dirPath).toString()
        @Assert(res, origin)
    }
}

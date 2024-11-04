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
        public init()
        public func setRepository(tempRepository:Option<Directory>):Unit
        测试场景: 空构造，设置的Repository成功
    ***/
    @TestCase
    func testDiskFileItemFactory02(): Unit {
        let dff = DiskFileItemFactory()

        let dirPath:Path = Path("./dirfactory2")
        if(!exists(dirPath)) {
            Directory.create(dirPath)
        }
        var dir = Directory(dirPath)

        dff.setRepository(dir)

        let info = dff.getRepository().getOrThrow().info
        let res =  canonicalize(info.path).toString()
        let origin = canonicalize(dirPath).toString()
        @Assert(res, origin)
    }
}

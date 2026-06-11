// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import cangjie_tpc::upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

@Test
public class TestDiskFileItemFactory {
    /***
        public init()
        public func setRepository(tempRepository:Option<Path>):Unit
        测试场景: 空构造，设置的Repository成功
    ***/
    @TestCase
    func testDiskFileItemFactory02(): Unit {
        let dff = DiskFileItemFactory()

        let dirPath:Path = Path("./dirfactory2")
        if(!exists(dirPath)) {
            Directory.create(dirPath)
        }

        dff.setRepository(dirPath)

        let info = dff.getRepository().getOrThrow()
        let res =  canonicalize(info).toString()
        let origin = canonicalize(dirPath).toString()
        @Assert(res, origin)
    }
}

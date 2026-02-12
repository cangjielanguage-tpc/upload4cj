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
        public init(sizeThreshold: Int64, repository: Option<Path>)
        public func getRepository():Option<Path>
        测试场景: 非空构造，返回默认构造的repository
    ***/
    @TestCase
    func testDiskFileItemFactory02(): Unit {
        let dirPath:Path = Path("./dirfactory")
        if(!exists(dirPath)) {
            Directory.create(dirPath)
        }
        let dff = DiskFileItemFactory(128, dirPath)
        let info = dff.getRepository().getOrThrow()
        let res =  canonicalize(info).toString()
        let origin = canonicalize(dirPath).toString()
        @Assert(res, origin)
    }
}

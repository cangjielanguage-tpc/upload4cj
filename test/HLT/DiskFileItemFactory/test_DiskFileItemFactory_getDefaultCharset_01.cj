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
        public func getDefaultCharset(): String
        测试场景: 空构造，默认返回 UTF-8
    ***/
    @TestCase
    func testDiskFileItemFactoryGetDefaultCharset01(): Unit {
        let dff = DiskFileItemFactory()
        @Assert(dff.getDefaultCharset(), "UTF-8")
    }
}

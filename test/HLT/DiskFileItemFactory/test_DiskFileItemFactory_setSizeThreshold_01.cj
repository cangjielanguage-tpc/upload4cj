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
        public func setSizeThreshold(tempSizeThreshold:Int64):Unit
        测试场景: 返回设置的 tempSizeThreshold
    ***/
    @TestCase
    func testDiskFileItemFactory02(): Unit {
        let dff = DiskFileItemFactory()
        dff.setSizeThreshold(11111)
        @Assert(dff.getSizeThreshold(), 11111)
    }
}

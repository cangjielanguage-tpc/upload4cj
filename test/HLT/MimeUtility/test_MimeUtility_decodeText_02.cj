// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

@Test
public class TestMimeUtility {
    /***
        public static func decodeText(text: String): Option<String>
        测试场景:  传入特殊字符=?，解析返回原字符串
    ***/
    @TestCase
    func testMimeUtilityDecodeText02(): Unit {
        var res = MimeUtility.decodeText("=?").getOrThrow()
        @Assert(res, "=?")
    }
}

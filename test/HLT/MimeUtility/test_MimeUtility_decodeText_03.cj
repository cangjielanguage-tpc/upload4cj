// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj



import cangjie_tpc::upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

@Test
public class TestMimeUtility {
    /***
        public static func decodeText(text: String): Option<String>
        测试场景:  编码解析成功，和对标库保持一致
    ***/
    @TestCase
    func testMimeUtilityDecodeText03(): Unit {
        var res = MimeUtility.decodeText("=?ISO-8859-1?B?SWYgeW91IGNhbiByZWFkIHRoaXMgeW8=?= =?ISO-8859-2?B?dSB1bmRlcnN0YW5kIHRoZSBleGFtcGxlLg==?=\"\n").getOrThrow()
        @Assert(res, "If you can read this you understand the example.")
    }
}

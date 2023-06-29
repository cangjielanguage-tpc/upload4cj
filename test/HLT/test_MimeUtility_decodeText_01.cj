// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/uuid

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

@Test
public class TestMimeUtility {
    /***
        public static func decodeText(text: String): Option<String>
        测试场景:  带空格编码解析成功，和对标库保持一致
    ***/
    @TestCase
    func testMimeUtilityDecodeText01(): Unit {
        var res = MimeUtility.decodeText("=?ISO-8859-1?B?SWYgeW91IGNhbiByZWFkIHRoaXMgeW8=?=\t  \r\n   =?ISO-8859-2?B?dSB1bmRlcnN0YW5kIHRoZSBleGFtcGxlLg==?=\"\r\n").getOrThrow()
        @Assert(res, "If you can read this you understand the example.")
    }
}
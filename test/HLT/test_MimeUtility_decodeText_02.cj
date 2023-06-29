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
        测试场景:  传入特殊字符=?，解析返回原字符串
    ***/
    @TestCase
    func testMimeUtilityDecodeText02(): Unit {
        var res = MimeUtility.decodeText("=?").getOrThrow()
        @Assert(res, "=?")
    }
}
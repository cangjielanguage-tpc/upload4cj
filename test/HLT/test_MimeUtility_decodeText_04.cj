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
        测试场景: 两种格式解析成功且相等，和对标库保持一致
    ***/
    @TestCase
    func testMimeUtilityDecodeText04(): Unit {
        var res1 = MimeUtility.decodeText("=?UTF-8?Q?_h=C3=A9!_=C3=A0=C3=A8=C3=B4u_!!!?=").getOrThrow()
        var res2 = MimeUtility.decodeText("=?UTF-8?B?IGjDqSEgw6DDqMO0dSAhISE=?=").getOrThrow()
        @Assert(res1, res2)
        @Assert(res2, " hé! àèôu !!!")
    }
}
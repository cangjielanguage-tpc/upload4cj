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
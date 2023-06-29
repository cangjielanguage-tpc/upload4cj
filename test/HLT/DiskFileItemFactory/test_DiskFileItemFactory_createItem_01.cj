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
        public override func createItem(fieldName: String, contentType: String, isFormField: Bool, fileName: String):FileItem
        测试场景: 构造对应的DiskFileItem
    ***/
    @TestCase
    func testDiskFileItemFactory02(): Unit {
        let dff = DiskFileItemFactory()
        let dfs: DiskFileItem = (dff.createItem("name1" , "text/html; charset=utf16" , false, "testfile") as DiskFileItem).getOrThrow()
        @Assert(dfs.getCharSet(), "utf16")
        @Assert(dfs.getFieldName(), "name1")
        @Assert(dfs.isGetFormField(), false)
    }
}
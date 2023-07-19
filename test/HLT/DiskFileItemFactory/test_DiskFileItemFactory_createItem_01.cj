// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj

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

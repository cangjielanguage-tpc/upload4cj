// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

@Test
public class TestDiskFileItem {
    /***
        public init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int64, repository: Option<Directory>)
        public override func getInputStream(): InputStream
        测试场景:  未缓存值 ,空值异常
    ***/
    @TestCase
    func testDiskFileItemGetInputStream01(): Unit {
        let dfs = DiskFileItem("a1" , "diskfile" , false, "testfile" , 129 , Option<Directory>.None)
        var flag = 1
        try {
            var res = dfs.getInputStream()
        } catch (e: NoneValueException) {
            flag = 0
        }
        @Assert(flag, 0)
    }
}
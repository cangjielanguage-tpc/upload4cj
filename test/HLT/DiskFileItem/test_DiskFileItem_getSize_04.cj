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
public class TestDiskFileItem {
    /***
        public init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int64, repository: Option<Directory>)
        public override func getSize(): Int64
        测试场景: 写两次数据中间缓存一次，无异常，size为缓存的大小
    ***/
    @TestCase
    func testDiskFileItemGetSize02(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Directory>.None)
        var flag= 0
        try {
            var out = dfs.getOutputStream()
            out.write([45,23,22,43])
            dfs.getInputStream()
            out.write([5,2,2,3,7])
            let size = dfs.getSize()
            @Assert(size, 4)
        } catch (e: NoneValueException) {
            flag = 1
        }
        @Assert(flag, 0)
    }
}

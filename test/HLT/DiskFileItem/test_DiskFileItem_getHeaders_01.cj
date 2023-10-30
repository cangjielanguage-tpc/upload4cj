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
        public override func getHeaders(): FileItemHeaders
        测试场景: 返回默认空 FileItemHeadersImpl, 迭代取值返回空
    ***/
    @TestCase
    func testDiskFileItemIsSetFormField01(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Directory>.None)
        var headers = dfs.getHeaders()
        var headerName: Iterator<String> = headers.getHeaderNames()
        var flag = 1
        try {
            headerName.next().getOrThrow()
        } catch (e: NoneValueException) {
            flag = 0
        }
        @Assert(flag, 0)
    }
}

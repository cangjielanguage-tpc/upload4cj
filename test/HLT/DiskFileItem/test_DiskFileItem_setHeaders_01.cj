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
        public override func setHeaders(pHeaders: FileItemHeaders)
        测试场景: 返回设置的 FileItemHeaders
    ***/
    @TestCase
    func testDiskFileItemIssetHeaders01(): Unit {
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Directory>.None)
        var headers: FileItemHeadersImpl = FileItemHeadersImpl()
        headers.addHeader("testheader1", "headerValue1")
        headers.addHeader("testheader2", "headerValue2")
        headers.addHeader("testheader3", "headerValue3")
        dfs.setHeaders(headers)

        var headerName: Iterator<String> = dfs.getHeaders().getHeaderNames()
        let a:String = headerName.next().getOrThrow()
        let b:String = headerName.next().getOrThrow()
        let c:String = headerName.next().getOrThrow()
        @Assert(a, "testheader1")
        @Assert(b, "testheader2")
        @Assert(c, "testheader3")
    }
}
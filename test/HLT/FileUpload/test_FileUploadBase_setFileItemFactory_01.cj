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
public class TestFileUploadBase {
    /***
        public init()
        public override func setFileItemFactory(factory: Option<FileItemFactory>)
        测试场景:  空构造返回None，set后非None
    ***/
    @TestCase
    func testFileUploadBaseSetFileItemFactory02(): Unit {
        var fu = FileUpload()
        var flag = 1
        match (fu.getFileItemFactory()) {
            case Some(_) => flag = 1
            case None => flag = 0
        }
        @Assert(flag, 0)

        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        fu.setFileItemFactory(fileItemFactory)
        match (fu.getFileItemFactory()) {
            case Some(_) => flag = 0
            case None => flag = 1
        }
        @Assert(flag, 0)
    }
}

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
public class TestFileUploadBase {
    /***
        public init() 
        public func getItemIterator(ctx: RequestContext): FileItemIterator 
        测试场景:  不抛弃异常分支
    ***/
    @TestCase
    func testFileUploadBaseGetItemIterator01(): Unit {
        var flag = 0
        var fu = FileUpload()
        var text ="-----1234" 
        let bytes: Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        let req =Request(RequestMethod.POST, "http://127.0.0.1/",output)
        let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"
        req.header.add("Content-Type", CONTENT_TYPE)
        try {
            fu.getItemIterator(ServletRequestContext(req))
        } catch (e: Exception){
            flag = 1
        }
        @Assert(flag, 0)
    }
}
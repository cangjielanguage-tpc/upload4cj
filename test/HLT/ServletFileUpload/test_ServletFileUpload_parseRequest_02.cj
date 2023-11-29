// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj
// dependence: ../upload_common_values.cj

@Test
public class TestServletFileUpload{
    /***
        public init(fileItemFactory: FileItemFactory)
        public func parseRequest(request: Request): Option<ArrayList<FileItem>>
        测试场景:返回值准确
    ***/
    @TestCase
    func testServletFileUploadParseRequest02(): Unit {
        let content= "-----1234\r\n" +
                    "Content-Disposition: form-data; name=\"utf8Html\"\r\n" +
                    "\r\n" +
                    "This is the content of the file\n" +
                    "\r\n" +
                    "-----1234--\r\n"
        var body_in=ByteArrayStream()
        body_in.write(content.toArray())
        let fileItemFactory=DiskFileItemFactory()
        let servletFileUpload=ServletFileUpload(fileItemFactory)
        let request = HttpRequestBuilder().method("GET").url("http://www.baidu.com").body(body_in).build()
        request.headers.add("Content-Type","multipart/form-data; boundary=---1234")
        var re=servletFileUpload.parseRequest(request).getOrThrow()
        @Assert(re.size,1)
        @Assert(re[0].isInMemory(),true)
        @Assert(re[0].getSize(),32)
        @Assert(re[0].getString(),"This is the content of the file\n")
    }
}

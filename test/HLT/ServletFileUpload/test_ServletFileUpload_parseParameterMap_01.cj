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
        public func parseParameterMap(request: Request): Map<String, ArrayList<FileItem>>
        测试场景:返回值准确
    ***/
    @TestCase
    func testServletFileUploadParseParameterMap01(): Unit {
        let content= "-----1234\r\n" +
                    "Content-Disposition: form-data; name=\"utf8Html\"\r\n" +
                    "\r\n" +
                    "This is the content of the file\n" +
                    "\r\n" +
                    "-----1234--\r\n"
        var body_in=ByteArrayStream()
        body_in.write(content.toUtf8Array())
        let fileItemFactory=DiskFileItemFactory()
        let servletFileUpload=ServletFileUpload(fileItemFactory)
        let request = HttpRequestBuilder.new().method("GET").url("http://www.baidu.com").body(body_in).build()
        request.headers.add("Content-Type","multipart/form-data; boundary=---1234")
        var re=servletFileUpload.parseParameterMap(request)
        @Assert(re.size,1)
        let list=re.get("utf8Html").getOrThrow()
        @Assert(list.size,1)
        @Assert(list[0].getFieldName(),"utf8Html")
        @Assert(list[0].getSize(),32)
    }
}

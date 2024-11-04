// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj

@Test
public class TestThresholdingOutputStream{
    /***
        public init()
        public func getItemIterator(request:Request):FileItemIterator
        测试场景:调用FileUploadBase的parseRequest,能返回值即可
    ***/

    @TestCase
    func testServletFileUploadGetItemIterator01(): Unit {
        let content= "-----1234\r\n" +
                    "Content-Disposition: form-data; name=\"utf8Html\"\r\n" +
                    "\r\n" +
                    "This is the content of the file\n" +
                    "\r\n" +
                    "-----1234--\r\n"
        var body_in=ByteBuffer()
        body_in.write(content.toArray())
        let fileItemFactory=DiskFileItemFactory()
        let servletFileUpload=ServletFileUpload(fileItemFactory)
        let request = HttpRequestBuilder().method("GET").url("http://www.baidu.com").body(body_in).build()
        request.headers.add("Content-Type","multipart/form-data; boundary=---1234")
        var re=servletFileUpload.getItemIterator(request)
        re.next()
        var re_flag=1
        try{
            re.next()
        }catch(e:Exception){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
}

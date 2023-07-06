// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestServletFileUpload{
    /***
        public init()
        public func parseRequest(request: Request): Option<ArrayList<FileItem>>
        测试场景:调用FileUploadBase的parseRequest,能返回值即可
    ***/

    @TestCase
    func testServletFileUploadParseRequest01(): Unit {
        let content= "-----1234\r\n" +
                    "Content-Disposition: form-data; name=\"utf8Html\"\r\n" +
                    "\r\n" +
                    "This is the content of the file\n" +
                    "\r\n" +
                    "-----1234--\r\n"
        var body_in=ByteArrayStream()
        body_in.write(content.toUtf8Array())
        let servletFileUpload=ServletFileUpload()
        let request=http.Request(RequestMethod.GET,"http://www.baidu.com")
        request.body=body_in
        var head_ori=Header()
        head_ori.add("Content-Type","multipart/form-data; boundary=---1234")
        request.header=head_ori
        var re_flag=1
        try{
            servletFileUpload.parseRequest(request)
        }catch(e:NullPointerException){
            if(e.toString().contains("No FileItemFactory has been set")){
                re_flag=0
            }
        }
        @Assert(re_flag,0)
    }
}
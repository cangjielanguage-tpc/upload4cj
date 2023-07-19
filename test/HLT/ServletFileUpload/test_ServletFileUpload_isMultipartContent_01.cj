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
        public static func isMultipartContent(request: Request):Bool
        测试场景:request是/否POST请求,request的contenType是否为none,contentType是否以multipart/开头
    ***/
    @TestCase
    func testServletFileUploadIsMultipartContent01(): Unit {
        let request=http.Request(RequestMethod.GET,"http://www.baidu.com")
        var re=ServletFileUpload.isMultipartContent(request)
        @Assert(re,false)
    }
    @TestCase
    func testServletFileUploadIsMultipartContent02(): Unit {
        let request=http.Request(RequestMethod.POST,"http://www.baidu.com")
        var re=ServletFileUpload.isMultipartContent(request)
        @Assert(re,false)
    }
    @TestCase
    func testServletFileUploadIsMultipartContent03(): Unit {
        let request=http.Request(RequestMethod.POST,"http://www.baidu.com")
        var head_ori=Header()
        head_ori.add("Content-type","Content-type-value")
        request.header=head_ori
        var re=ServletFileUpload.isMultipartContent(request)
        @Assert(re,false)
    }
    @TestCase
    func testServletFileUploadIsMultipartContent04(): Unit {
        let request=http.Request(RequestMethod.POST,"http://www.baidu.com")
        var head_ori=Header()
        head_ori.add("Content-type","multipart/form-data")
        request.header=head_ori
        var re=ServletFileUpload.isMultipartContent(request)
        @Assert(re,true)
    }
}

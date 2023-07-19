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
public class TestStreams{
    /***
        public init(request: Request)
        public override func contentLength(): Int64
        测试场景:request有/无报文头"Content-length"
    ***/
    @TestCase
    func testServletRequestContextGetContentType01(): Unit {
        let request=http.Request(RequestMethod.GET,"http://www.baidu.com")
        var head_ori=Header()
        head_ori.add("Content-length","123455")
        request.header=head_ori
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.contentLength()
        @Assert(re,123455)
    }
    @TestCase
    func testServletRequestContextGetContentType02(): Unit {
        let request=http.Request(RequestMethod.GET,"http://www.baidu.com")
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.contentLength()
        @Assert(re,request.contentLength)
    }

}

// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
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
        let request = HttpRequestBuilder().method("GET").url("http://www.baidu.com").build()
        request.headers.add("Content-length","123455")
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.contentLength()
        @Assert(re,123455)
    }
    @TestCase
    func testServletRequestContextGetContentType02(): Unit {
        let request = HttpRequestBuilder().method("GET").url("http://www.baidu.com").build()
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.contentLength()
        @Assert(re,request.bodySize.getOrThrow())
    }

}

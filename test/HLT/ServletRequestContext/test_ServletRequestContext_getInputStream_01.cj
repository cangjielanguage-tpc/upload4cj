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
        public override func getInputStream(): InputStream
        测试场景:返回request的body
    ***/
    @TestCase
    func testServletRequestContextGetInputStream01(): Unit {
        var request = HttpRequestBuilder.new().method("GET").url("http://www.baidu.com").build()
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.getInputStream()
        @Assert(re.length,0)
    }
    @TestCase
    func testServletRequestContextGetInputStream02(): Unit {
        let body_in=ByteArrayStream()
        let body_arr=Array<UInt8>(100,item:9)
        body_in.write(body_arr)
        var request = HttpRequestBuilder.new().method("GET").url("http://www.baidu.com").body(body_in).build()
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.getInputStream()
        @Assert(re.length,body_in.length)
    }
}

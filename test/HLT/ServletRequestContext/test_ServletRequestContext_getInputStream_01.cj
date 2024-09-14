// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
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
        var request = HttpRequestBuilder().method("GET").url("http://www.baidu.com").build()
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.getInputStream()
        var buff=Array<Byte>(10,repeat:0)
        @Assert(re.read(buff),0)
        //@Assert(re.length,0)
    }
    @TestCase
    func testServletRequestContextGetInputStream02(): Unit {
        let body_in=ByteArrayStream()
        let body_arr=Array<UInt8>(100,repeat:9)
        body_in.write(body_arr)
        var request = HttpRequestBuilder().method("GET").url("http://www.baidu.com").body(body_in).build()
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.getInputStream()
        var buff=Array<Byte>(200,repeat:0)
        @Assert(re.read(buff),100)
        //@Assert(re.length,body_in.length)
    }
}

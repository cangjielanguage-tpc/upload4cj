// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
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
        let request=http.Request(RequestMethod.GET,"http://www.baidu.com")
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.getInputStream()
        @Assert(re.length,0)
    }
    @TestCase
    func testServletRequestContextGetInputStream02(): Unit {
        let request=http.Request(RequestMethod.GET,"http://www.baidu.com")
        let body_in=ByteArrayStream()
        let body_arr=Array<UInt8>(100,item:9)
        body_in.write(body_arr)
        request.body=body_in
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.getInputStream()
        @Assert(re.length,body_in.length)
    }
}
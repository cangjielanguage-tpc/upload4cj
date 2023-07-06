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
public class TestStreams{
    /***
        public init(request: Request)
        public func toString(): String
        测试场景:返回request的body
    ***/
    @TestCase
    func testServletRequestContextToString01(): Unit {
        let request=http.Request(RequestMethod.GET,"http://www.baidu.com")
        let body_in=ByteArrayStream()
        let body_arr=Array<UInt8>(100,item:9)
        body_in.write(body_arr)
        request.body=body_in
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.toString()
        let exp_re="ContentLength = ${servletRequestContext.contentLength()}, ContentType = ${servletRequestContext.getContentType()}"
        @Assert(re,exp_re)
    }
}
// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestStreams{
    /***
        public init(request: Request)
        public override func getCharacterEncoding(): Option<String>
        测试场景:默认显示字符编码utf-8
    ***/
    @TestCase
    func testServletRequestContextGetCharacterEncoding01(): Unit {
        let request=http.Request(RequestMethod.GET,"http://www.baidu.com")
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.getCharacterEncoding().getOrThrow()
        @Assert(re,"UTF-8")
    }
}
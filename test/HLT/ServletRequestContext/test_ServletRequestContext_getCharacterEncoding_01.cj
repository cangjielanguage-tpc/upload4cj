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
        public override func getCharacterEncoding(): Option<String>
        测试场景:默认显示字符编码utf-8
    ***/
    @TestCase
    func testServletRequestContextGetCharacterEncoding01(): Unit {
        let request = HttpRequestBuilder.new().method("GET").url("http://www.baidu.com").build()
        let servletRequestContext=ServletRequestContext(request)
        var re=servletRequestContext.getCharacterEncoding().getOrThrow()
        @Assert(re,"UTF-8")
    }
}

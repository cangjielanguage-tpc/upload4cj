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
public class TestFileItemHeadersImpl{
    /***
        public override func getHeaderNames(): Iterator<String>
        public override func getHeaders(name:String): Iterator<String>
        测试场景:默认场景/新增场景(存在/不存在)
    ***/
    @TestCase
    func testFileItemHeadersImplgetHeaderNames01(): Unit {
        var fhi = FileItemHeadersImpl()
        var re=fhi.getHeaderNames().next()
        var flag=1
        try{
            re.getOrThrow()
        }catch(e:NoneValueException){
            flag=0
        }
        @Assert(flag,0)
    }
    @TestCase
    func testFileItemHeadersImplgetHeaders01(): Unit {
        var fhi = FileItemHeadersImpl()
        fhi.addHeader("key01","header01")
        fhi.addHeader("key01","header02")
        fhi.addHeader("key02","header02")
        var re=fhi.getHeaders("key01")
        var name=re.next().getOrThrow()
        @Assert(name,"header01")
        name=re.next().getOrThrow()
        @Assert(name,"header02")
        re=fhi.getHeaders("key02")
        name=re.next().getOrThrow()
        @Assert(name,"header02")
    }
}

// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj

@Test
public class TestFileItemHeadersImpl{
    /***
        public override func getHeader(name:String): Option<String>
        public func addHeader(name:String,value:String):Unit
        测试场景:默认场景/新增场景(存在/不存在)
    ***/
    @TestCase
    func testFileItemHeadersImplHeader01(): Unit {
        var fhi = FileItemHeadersImpl()
        var re=fhi.getHeader("")
        var flag=1
        try{
            re.getOrThrow()
        }catch(e:NoneValueException){
            flag=0
        }
        @Assert(flag,0)
        fhi.addHeader("key01","header01")
        re=fhi.getHeader("key01")
        @Assert(re.getOrThrow(),"header01")
    }
}

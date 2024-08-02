// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj



@Test
public class TestStreams{
    /***
        public static func checkFileName(fileName:Option<String>):Option<String>
        测试场景:fileName为Option<String>.None
    ***/
    @TestCase
    func testStreamsCheckFileName01(): Unit {
        let fileName=Option<String>.None
        var re_flag=1
        try{
            Streams.checkFileName(fileName).getOrThrow()
        }catch(e:NoneValueException){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
}

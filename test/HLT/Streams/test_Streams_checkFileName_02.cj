// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj



@Test
public class TestStreams{
    /***
        public static func checkFileName(fileName:Option<String>):Option<String>
        测试场景:fileName非Option<String>.None,且fileName中包含\u{0}
    ***/
    @TestCase
    func testStreamsCheckFileName02(): Unit {
        let fileName=Option<String>.Some("file\u{0}Name")
        var re_flag=1
        try{
            Streams.checkFileName(fileName)
        }catch(e:InvalidFileNameException){
            if(e.toString().contains("InvalidFileNameException: Invalid file name: file\\0Name")){
                re_flag=0
            }
        }
        @Assert(re_flag,0)
    }
}

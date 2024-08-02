// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj



@Test
public class TestStreams{
    /***
        public static func copy(inputStream:Option<InputStream>,outputStream:Option<OutputStream>,closeOutputStream:Bool,buffer:Array<UInt8>):Int64
        测试场景:inputStream,outputStream为Option.None,closeOutputStream为true,buffer为空
    ***/
    @TestCase
    func testStreamsCopy0101(): Unit {
        let inputStream=Option<InputStream>.None
        let outputStream=Option<OutputStream>.None
        var re_flag=1
        try{
            Streams.copy(inputStream,outputStream,true,Array<UInt8>())
        }catch(e:NoneValueException){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
}

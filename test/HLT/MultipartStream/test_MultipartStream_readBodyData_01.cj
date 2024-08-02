// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj

@Test
public class TestMultipartStream{
    /***
        public func readBodyData(outputStream:Option<OutputStream>):Int64
        测试场景:outputStream非Option.None
    ***/
    @TestCase
    func testMultipartStreamReadBodyData01(): Unit {
        let input=ByteArrayStream()
        var boundary_arr="8888888888".toArray()
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let pNotifier=Option<ProgressNotifier>.None
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
        let output_s=ByteArrayStream()
        let output=Option<OutputStream>.Some(output_s)
        var re_flag=1
        try{
            multipartStream.readBodyData(output)
        }catch(e:MalformedStreamException){
            println(e.toString())
            if(e.toString().contains("Stream ended unexpectedly")){
                re_flag=0
            }
        }
        @Assert(re_flag,0)
    }
}

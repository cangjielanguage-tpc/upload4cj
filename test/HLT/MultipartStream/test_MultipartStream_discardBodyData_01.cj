// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestMultipartStream{
    /***
        public func discardBodyData():Int64
        测试场景:默认获取准确
    ***/
    @TestCase
    func testMultipartStreamDiscardBodyData01(): Unit {
        let input=ByteArrayStream()
        var boundary_arr="8888888888".toUtf8Array()
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let pNotifier=Option<ProgressNotifier>.None
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
        let output_s=ByteArrayStream()
        let output=Option<OutputStream>.None
        var re_flag=1
        try{
            multipartStream.discardBodyData()
        }catch(e:MalformedStreamException){
            if(e.toString().contains("Stream ended unexpectedly")){
                re_flag=0
            }
        }
        @Assert(re_flag,0)
    }
}
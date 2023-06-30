// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestMultipartStream{
    /***
        public func readByte(): UInt8
        测试场景:构造器input为空
    ***/
    @TestCase
    func testMultipartStreamReadByte01(): Unit {
        let input=ByteArrayStream()
        var boundary_arr="8888888888".toUtf8Array()
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let pNotifier=Option<ProgressNotifier>.None
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
        let encoding="utf-8"
        var re_flag=1
        try{
            multipartStream.readByte()
        }catch(e:Exception){
            if(e.toString().contains("No more data is available")){
                re_flag=0
            }
        }
        @Assert(re_flag,0)
    }
}
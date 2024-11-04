// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj

@Test
public class TestMultipartStream{
    /***
        public func readByte(): UInt8
        测试场景:构造器input为空
    ***/
    @TestCase
    func testMultipartStreamReadByte01(): Unit {
        let input=ByteBuffer()
        var boundary_arr="8888888888".toArray()
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let pNotifier=Option<ProgressNotifier>.None
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
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

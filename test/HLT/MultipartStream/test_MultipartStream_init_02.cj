// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj

@Test
public class TestMultipartStream{
    /***
        public init (input: InputStream, boundary: Option<Array<UInt8>>, bufSize: Int64, pNotifier: Option<ProgressNotifier>)
        测试场景:boundary非Option<Array<UInt8>>.None，但是bufSize<boundary.size+4
    ***/
    let input=ByteBuffer()
    var boundary_arr="8888888888".toArray()
    var boundary=Option<Array<UInt8>>.Some(boundary_arr)
    let bufSize=boundary_arr.size+4
    let pNotifier=Option<ProgressNotifier>.None
    @TestCase
    func testMultipartStreamInit02(): Unit {
        var re_flag=1
        try{
            MultipartStream(input,boundary,bufSize,pNotifier)
        }catch(e:IllegalArgumentException){
            if(e.toString().contains("The buffer size specified for the MultipartStream is too small")){
                re_flag=0
            }
        }
        @Assert(re_flag,0)
    }
}

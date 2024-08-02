// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj


@Test
public class TestMultipartStream{
    /***
        public func setBoundary(boundary: Array<UInt8>)
        测试场景:boundary为空,boundary前后长度不一致
    ***/
    @TestCase
    func testMultipartStreamReadBoundary01(): Unit {
        let input=ByteArrayStream()
        var boundary_arr="8888888888".toArray()
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let pNotifier=Option<ProgressNotifier>.None
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
        var re_flag=1
        try{
            multipartStream.setBoundary(Array<UInt8>())
        }catch(e:IllegalBoundaryException){
            if(e.toString().contains("The length of a boundary token cannot be changed")){
                re_flag=0
            }
        }
        @Assert(re_flag,0)
    }
}

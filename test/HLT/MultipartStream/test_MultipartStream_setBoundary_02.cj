// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestMultipartStream{
    /***
        public func setBoundary(boundary: Array<UInt8>)
        测试场景:boundary非空,boundary前后长度一致
    ***/
    @TestCase
    func testMultipartStreamReadBoundary02(): Unit {
        let input=ByteArrayStream()
        var boundary_arr="888888888".toUtf8Array()
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let pNotifier=Option<ProgressNotifier>.None
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
        var boundary_after="333333333".toUtf8Array()
        var re_flag=1
        try{
            multipartStream.setBoundary(boundary_after)
        }catch(e:Exception){
            re_flag=0
        }
        @Assert(re_flag,1)

    }
}
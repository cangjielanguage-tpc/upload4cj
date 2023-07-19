// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj
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

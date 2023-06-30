// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestMultipartStream{
    /***
        public func skipPreamble():Bool
        测试场景:结果为false
    ***/
    @TestCase
    func testMultipartStreamSkipPreamble01(): Unit {
        let input=ByteArrayStream()
        var boundary_arr="8888888888".toUtf8Array()
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let pNotifier=Option<ProgressNotifier>.None
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
        let re=multipartStream.skipPreamble()
        @Assert(re,false)
    }
}
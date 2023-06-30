// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestMultipartStream{
    /***
        public func readByte(): UInt8
        测试场景:构造器input不为空，pNotifier非Option<ProgressNotifier>.None,且pNotifie的构造中ProgressListener为Option<ProgressListener>.None
    ***/
    @TestCase
    func testMultipartStreamReadByte02(): Unit {
        let input=ByteArrayStream()
        var boundary_arr="8888888888".toUtf8Array()
        input.write(boundary_arr)
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let progressNotifier=ProgressNotifier(Option<ProgressListener>.None,123)
        let pNotifier=Option<ProgressNotifier>.Some(progressNotifier)
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
        let re=multipartStream.readByte()
        @Assert(re,UInt8(56))
    }
}
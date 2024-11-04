// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj


@Test
public class TestMultipartStream{
    /***
        public func readByte(): UInt8
        测试场景:构造器input不为空，pNotifier为Option<ProgressNotifier>.None
    ***/
    @TestCase
    func testMultipartStreamReadByte02(): Unit {
        let input=ByteBuffer()
        var boundary_arr="8888888888".toArray()
        input.write(boundary_arr)
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let pNotifier=Option<ProgressNotifier>.None
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
        let re=multipartStream.readByte()
        @Assert(re,UInt8(56))
    }
}

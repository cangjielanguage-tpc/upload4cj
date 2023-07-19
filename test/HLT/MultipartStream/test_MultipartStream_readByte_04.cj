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
        public func readByte(): UInt8
        测试场景:构造器input不为空，pNotifier非Option<ProgressNotifier>.None,且pNotifie的构造中ProgressListener非Option<ProgressListener>.None
    ***/
    @TestCase
    func testMultipartStreamReadByte04(): Unit {
        let input=ByteArrayStream()
        var boundary_arr="8888888888".toUtf8Array()
        input.write(boundary_arr)
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let subProgressListener=SubProgressListener()
        let progressNotifier=ProgressNotifier(Option<ProgressListener>.Some(subProgressListener),123)
        let pNotifier=Option<ProgressNotifier>.Some(progressNotifier)
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
        let re=multipartStream.readByte()
        @Assert(re,UInt8(56))
        @Assert(subProgressListener.re_SubProgressListener,133)
    }
}

public class SubProgressListener <: ProgressListener {
    public var re_SubProgressListener=0
    public func update(pBytesRead: Int64, pContentLength: Int64, pItems: Int64): Unit{
        re_SubProgressListener=pBytesRead+pContentLength+pItems
    }
}

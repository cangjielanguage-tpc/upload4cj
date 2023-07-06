// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestMultipartStream{
    /***
        public func getHeaderEncoding(): Option<String>
        public func setHeaderEncoding(encoding: Option<String>)
        测试场景:设置后值准确,多次设置
    ***/
    @TestCase
    func testMultipartStreamSetHeaderEncoding01(): Unit {
        let input=ByteArrayStream()
        var boundary_arr="8888888888".toUtf8Array()
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let pNotifier=Option<ProgressNotifier>.None
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
        var encoding="utf-8"
        multipartStream.setHeaderEncoding(Option<String>.Some(encoding))
        var re=multipartStream.getHeaderEncoding().getOrThrow()
        @Assert(re,encoding)
        encoding="unicode"
        multipartStream.setHeaderEncoding(Option<String>.Some(encoding))
        re=multipartStream.getHeaderEncoding().getOrThrow()
        @Assert(re,encoding)
    }
}
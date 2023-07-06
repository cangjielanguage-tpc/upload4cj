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
public class TestStreams{
    /***
        public static func copy(inputStream:Option<InputStream>,outputStream:Option<OutputStream>,closeOutputStream:Bool):Int64
        测试场景:inputStream,outputStream非Option.None,但流中有内容,仅inputStream有,仅outputStream有,均有
    ***/
    let content="8888888888".toUtf8Array()

    @TestCase
    func testStreamsCopy0201(): Unit {
        let in_byteArrayStream=ByteArrayStream()
        in_byteArrayStream.write(content)
        let out_byteArrayStream=ByteArrayStream()
        let inputStream=Option<InputStream>.Some(in_byteArrayStream)
        let outputStream=Option<OutputStream>.Some(out_byteArrayStream)
        let closeOutputStream=true
        let re=Streams.copy(inputStream,outputStream,closeOutputStream)
        @Assert(re,10)
        let re_arr=(outputStream.getOrThrow() as ByteArrayStream).getOrThrow().readToEnd()
        @Assert(re_arr,content)
    }

    @TestCase
    func testStreamsCopy0202(): Unit {
        let in_byteArrayStream=ByteArrayStream()
        let out_byteArrayStream=ByteArrayStream()
        out_byteArrayStream.write(content)
        let inputStream=Option<InputStream>.Some(in_byteArrayStream)
        let outputStream=Option<OutputStream>.Some(out_byteArrayStream)
        let closeOutputStream=true
        let re=Streams.copy(inputStream,outputStream,closeOutputStream)
        @Assert(re,0)
        let re_arr=(outputStream.getOrThrow() as ByteArrayStream).getOrThrow().readToEnd()
        @Assert(re_arr,content)
    }

    @TestCase
    func testStreamsCopy0203(): Unit {
        let in_byteArrayStream=ByteArrayStream()
        in_byteArrayStream.write(content)
        let out_byteArrayStream=ByteArrayStream()
        out_byteArrayStream.write(content)
        let inputStream=Option<InputStream>.Some(in_byteArrayStream)
        let outputStream=Option<OutputStream>.Some(out_byteArrayStream)
        let closeOutputStream=true
        let re=Streams.copy(inputStream,outputStream,closeOutputStream)
        @Assert(re,10)
        let re_arr=(outputStream.getOrThrow() as ByteArrayStream).getOrThrow().readToEnd()
        let exp_content="88888888888888888888".toUtf8Array()
        @Assert(re_arr,exp_content)
    }
}
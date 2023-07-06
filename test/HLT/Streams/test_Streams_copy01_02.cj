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
        public static func copy(inputStream:Option<InputStream>,outputStream:Option<OutputStream>,closeOutputStream:Bool,buffer:Array<UInt8>):Int64
        测试场景:inputStream,outputStream非Option.None,但流中无内容,closeOutputStream为true/false,buffer为空/非空
    ***/
    @TestCase
    func testStreamsCopy010201(): Unit {
        let in_byteArrayStream=ByteArrayStream()
        let out_byteArrayStream=ByteArrayStream()
        let inputStream=Option<InputStream>.Some(in_byteArrayStream)
        let outputStream=Option<OutputStream>.Some(out_byteArrayStream)
        let buffer=Array<UInt8>()
        let closeOutputStream=true
        let re=Streams.copy(inputStream,outputStream,closeOutputStream,buffer)
        @Assert(re,0)
    }
    @TestCase
    func testStreamsCopy010202(): Unit {
        let in_byteArrayStream=ByteArrayStream()
        let out_byteArrayStream=ByteArrayStream()
        let inputStream=Option<InputStream>.Some(in_byteArrayStream)
        let outputStream=Option<OutputStream>.Some(out_byteArrayStream)
        let buffer=Array<UInt8>(200,item:UInt8(0))
        let closeOutputStream=false
        let re=Streams.copy(inputStream,outputStream,closeOutputStream,buffer)
        @Assert(re,0)
    }
}
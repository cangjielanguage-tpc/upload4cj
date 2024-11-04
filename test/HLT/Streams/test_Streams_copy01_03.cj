// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj



@Test
public class TestStreams{
    /***
        public static func copy(inputStream:Option<InputStream>,outputStream:Option<OutputStream>,closeOutputStream:Bool,buffer:Array<UInt8>):Int64
        测试场景:inputStream,outputStream非Option.None,但流中有内容,仅inputStream有,仅outputStream有,均有
    ***/
    let content="8888888888".toArray()
    @TestCase
    func testStreamsCopy010301(): Unit {
        let in_ByteBuffer=ByteBuffer()
        in_ByteBuffer.write(content)
        let out_ByteBuffer=ByteBuffer()
        let inputStream=Option<InputStream>.Some(in_ByteBuffer)
        let outputStream=Option<OutputStream>.Some(out_ByteBuffer)
        let buffer=Array<UInt8>(10,repeat:UInt8(1))
        let closeOutputStream=true
        let re=Streams.copy(inputStream,outputStream,closeOutputStream,buffer)
        @Assert(re,10)
        let re_arr=readToEnd((outputStream.getOrThrow() as ByteBuffer).getOrThrow())
        @Assert(re_arr,content)
    }
    @TestCase
    func testStreamsCopy010302(): Unit {
        let in_ByteBuffer=ByteBuffer()
        let out_ByteBuffer=ByteBuffer()
        out_ByteBuffer.write(content)
        let inputStream=Option<InputStream>.Some(in_ByteBuffer)
        let outputStream=Option<OutputStream>.Some(out_ByteBuffer)
        let buffer=Array<UInt8>(10,repeat:UInt8(1))
        let closeOutputStream=true
        let re=Streams.copy(inputStream,outputStream,closeOutputStream,buffer)
        @Assert(re,0)
        let re_arr=readToEnd((outputStream.getOrThrow() as ByteBuffer).getOrThrow())
        @Assert(re_arr,content)
    }
    @TestCase
    func testStreamsCopy010303(): Unit {
        let in_ByteBuffer=ByteBuffer()
        in_ByteBuffer.write(content)
        let out_ByteBuffer=ByteBuffer()
        out_ByteBuffer.write(content)
        let inputStream=Option<InputStream>.Some(in_ByteBuffer)
        let outputStream=Option<OutputStream>.Some(out_ByteBuffer)
        let buffer=Array<UInt8>(10,repeat:UInt8(1))
        let closeOutputStream=true
        let re=Streams.copy(inputStream,outputStream,closeOutputStream,buffer)
        @Assert(re,10)
        let re_arr=readToEnd((outputStream.getOrThrow() as ByteBuffer).getOrThrow())
        let exp_content="88888888888888888888".toArray()
        @Assert(re_arr,exp_content)
    }
}

// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj


@Test
public class TestLimitedInputStream{
    /***
        public override func read(buffer: Array<UInt8>): Int64
        测试场景:数组为空
    ***/
    @TestCase
    func testLimitedInputStreamRead01(): Unit {
        let byteBuffer=ByteBuffer()
        let subLimitedInputStream=SubLimitedInputStream(byteBuffer,234)
        let re_int=subLimitedInputStream.read(Array<UInt8>())
        @Assert(re_int,0)
        let re_array=readToEnd(byteBuffer)
        @Assert(re_array.size,0)
    }
}


// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj

@Test
public class TestLimitedInputStream{
    /***
        public override func read(buffer: Array<UInt8>): Int64
        测试场景:数组非空,且长度小于等于pSizeMax
    ***/
    @TestCase
    func testLimitedInputStreamRead03(): Unit {
        var ori_array:Array<UInt8>=[1,2,3,4,5,6,7,8,8,9,8,8,8,8]
        let ByteBuffer=ByteBuffer()
        ByteBuffer.write(ori_array)
        let subLimitedInputStream=SubLimitedInputStream(ByteBuffer,ori_array.size)
        var re_array:Array<UInt8>=[0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        let re_int=subLimitedInputStream.read(re_array)
        @Assert(re_int,ori_array.size)
        @Assert(re_array,ori_array)
    }
}

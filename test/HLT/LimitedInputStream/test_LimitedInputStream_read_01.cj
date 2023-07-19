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
public class TestLimitedInputStream{
    /***
        public override func read(buffer: Array<UInt8>): Int64
        测试场景:数组为空
    ***/
    @TestCase
    func testLimitedInputStreamRead01(): Unit {
        let byteArrayStream=ByteArrayStream()
        let subLimitedInputStream=SubLimitedInputStream(byteArrayStream,234)
        let re_int=subLimitedInputStream.read(Array<UInt8>())
        @Assert(re_int,0)
        let re_array=byteArrayStream.readToEnd()
        @Assert(re_array.size,0)
    }
}


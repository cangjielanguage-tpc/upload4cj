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
public class TestThresholdingOutputStream{
    /***
        public func getThreshold(): Int64
        测试场景:刷新流
    ***/
    @TestCase
    func testThresholdingOutputStreamGetThreshold01(): Unit {
        let subThresholdingOutputStream=SubThresholdingOutputStream(123,Array<UInt8>(),0,0)
        let re=subThresholdingOutputStream.getThreshold()
        @Assert(re,123)
    }
}

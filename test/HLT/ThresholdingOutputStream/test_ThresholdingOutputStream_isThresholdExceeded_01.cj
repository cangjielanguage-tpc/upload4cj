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
public class TestThresholdingOutputStream{
    /***
        public func isThresholdExceeded(): Bool
        测试场景:返回值是true或者false
    ***/
    @TestCase
    func testThresholdingOutputStreamIsThresholdExceeded01(): Unit {
        let subThresholdingOutputStream=SubThresholdingOutputStream(123,Array<UInt8>(),0,0)
        var target=Array<UInt8>(123,item:UInt8(0))
        subThresholdingOutputStream.write(target)
        let re=subThresholdingOutputStream.isThresholdExceeded()
        @Assert(re,false)
    }
    @TestCase
    func testThresholdingOutputStreamIsThresholdExceeded02(): Unit {
        let subThresholdingOutputStream=SubThresholdingOutputStream(123,Array<UInt8>(),0,0)
        var target=Array<UInt8>(124,item:UInt8(0))
        subThresholdingOutputStream.write(target)
        let re=subThresholdingOutputStream.isThresholdExceeded()
        @Assert(re,true)
    }
}
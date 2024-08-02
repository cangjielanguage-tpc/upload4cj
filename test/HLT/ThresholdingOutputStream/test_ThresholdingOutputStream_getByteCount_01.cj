// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj



@Test
public class TestThresholdingOutputStream{
    /***
        public func getByteCount(): Int64
        public func write(b: Array<UInt8>)
        public func getByteCount(): Int64
        测试场景:写入为空和非空
    ***/
    @TestCase
    func testThresholdingOutputStreamGetByteCount01(): Unit {
        let subThresholdingOutputStream=SubThresholdingOutputStream(123,Array<UInt8>(),0,0)
        var re=subThresholdingOutputStream.getByteCount()
        @Assert(re,0)
        var target=Array<UInt8>()
        subThresholdingOutputStream.write(target)
        subThresholdingOutputStream.flush()
        re=subThresholdingOutputStream.getByteCount()
        @Assert(re,0)
    }
    @TestCase
    func testThresholdingOutputStreamGetByteCount02(): Unit {
        let subThresholdingOutputStream=SubThresholdingOutputStream(123,Array<UInt8>(),0,0)
        var target=Array<UInt8>([1,2,3])
        subThresholdingOutputStream.write(target)
        subThresholdingOutputStream.flush()
        let re=subThresholdingOutputStream.getByteCount()
        @Assert(re,target.size)
    }
}

// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj

@Test
public class TestMultipartStream{
    /***
        public static func arrayequals(a: Array<UInt8>, b: Array<UInt8>, count: Int64): Bool
        测试场景:比较数组均非空,count<=最小数组长度部分两数组对应的部分存在不等
    ***/
    @TestCase
    func testMultipartStreamArrayequals03(): Unit {
        let a:Array<UInt8>=[1,2,3,4,5]
        let b:Array<UInt8>=[3,4,5]
        let count=3
        let re=MultipartStream.arrayequals(a,b,count)
        @Assert(re,false)
    }
}

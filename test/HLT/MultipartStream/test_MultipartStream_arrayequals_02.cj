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
public class TestMultipartStream{
    /***
        public static func arrayequals(a: Array<UInt8>, b: Array<UInt8>, count: Int64): Bool
        测试场景:比较数组均非空,count<=最小数组长度部分两数组对应的部分完全相等
    ***/
    @TestCase
    func testMultipartStreamArrayequals0201(): Unit {
        let a=Array<UInt8>(8,item:UInt8(0))
        let b=Array<UInt8>(10,item:UInt8(0))
        let count=7
        let re=MultipartStream.arrayequals(a,b,count)
        @Assert(re,true)
    }
    @TestCase
    func testMultipartStreamArrayequals0202(): Unit {
        let a=Array<UInt8>(8,item:UInt8(0))
        let b=Array<UInt8>(10,item:UInt8(0))
        let count=8
        let re=MultipartStream.arrayequals(a,b,count)
        @Assert(re,true)
    }
}

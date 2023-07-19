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
        测试场景:a,b为空或非空,count大于最小数组长度
    ***/
    @TestCase
    func testMultipartStreamArrayequals0101(): Unit {
        let a=Array<UInt8>()
        let b=Array<UInt8>()
        let count=1
        var re_flag=1
        try{
            MultipartStream.arrayequals(a,b,count)
        }catch(e:IndexOutOfBoundsException){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
    @TestCase
    func testMultipartStreamArrayequals0102(): Unit {
        let a=Array<UInt8>(8,item:UInt8(0))
        let b=Array<UInt8>(10,item:UInt8(0))
        let count=9
        var re_flag=1
        try{
            MultipartStream.arrayequals(a,b,count)
        }catch(e:IndexOutOfBoundsException){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
}

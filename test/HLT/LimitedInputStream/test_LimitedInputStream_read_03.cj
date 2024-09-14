// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj

@Test
public class TestLimitedInputStream{
    /***
        public init(inputStream: InputStream, pSizeMax: Int64, stream: Option<ItemInputStream>)
        public override func read(buffer: Array<UInt8>): Int64
        测试场景:数组非空,且长度大于pSizeMax
    ***/
    @TestCase
    func testLimitedInputStreamRead03(): Unit {
        var ori_array:Array<UInt8>=[1,2,3,4,5,6,7,8,8,9,8,8,8,8]
        let byteArrayStream=ByteArrayStream()
        byteArrayStream.write(ori_array)
        let subLimitedInputStream=SubLimitedInputStream(byteArrayStream,ori_array.size-1)
        var re_array:Array<UInt8>=[0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        var re_flag=1
        try{
            subLimitedInputStream.read(re_array)
        }catch(e:IOException){
            if(e.toString().contains("raiseError")){
                re_flag=0
            }
        }
        @Assert(re_flag,0)
    }
}

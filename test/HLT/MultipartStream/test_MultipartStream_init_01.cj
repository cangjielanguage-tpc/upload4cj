// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestMultipartStream{
    /***
        public init (input: InputStream, boundary: Option<Array<UInt8>>, bufSize: Int64, pNotifier: Option<ProgressNotifier>)
        public init (input: InputStream, boundary: Option<Array<UInt8>>, pNotifier: Option<ProgressNotifier>)
        测试场景:boundary为Option<Array<UInt8>>.None
    ***/
    let input=ByteArrayStream()
    let boundary=Option<Array<UInt8>>.None
    let bufSize=100
    let pNotifier=Option<ProgressNotifier>.None
    @TestCase
    func testMultipartStreamInit0101(): Unit {
        var re_flag=1
        try{
            MultipartStream(input,boundary,bufSize,pNotifier)
        }catch(e:IllegalArgumentException){
            if(e.toString().contains("boundary may not be null")){
                re_flag=0
            }
        }
        @Assert(re_flag,0)
    }
    @TestCase
    func testMultipartStreamInit0102(): Unit {
        var re_flag=1
        try{
            MultipartStream(input,boundary,pNotifier)
        }catch(e:IllegalArgumentException){
            if(e.toString().contains("boundary may not be null")){
                re_flag=0
            }
        }
        @Assert(re_flag,0)
    }
}
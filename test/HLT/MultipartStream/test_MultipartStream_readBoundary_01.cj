// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj
// dependence: ../upload_common_values.cj


public let text =
            "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
public let boundaryString = "---1234"
@Test
public class TestMultipartStream{
    /***
        public func readBoundary(): Bool
        测试场景:读取值
    ***/
    @TestCase
    func testMultipartStreamReadBoundary01(): Unit {
        var input = ByteArrayStream()
        input.write(text.toUtf8Array())
        let boundary: Option<Array<UInt8>> = boundaryString.toUtf8Array()
        let notifier = Option<ProgressNotifier>.None
        var multipartStream: MultipartStream = MultipartStream(input, boundary, notifier)
        var flag=1
        try{
            multipartStream.readBoundary()
        }catch(e:MalformedStreamException){
            if(e.toString().contains("Stream ended unexpectedly")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
}

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
public let exp_bodydata="-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" + "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n"


@Test
public class TestMultipartStream{
    /***
        public func readBodyData(outputStream:Option<OutputStream>):Int64
        测试场景:有值
    ***/
    @TestCase
    func testMultipartStreamReadBodyData03(): Unit {
        let input=ByteArrayStream()
        input.write(text.toUtf8Array())
        var boundary_arr=boundaryString.toUtf8Array()
        var boundary=Option<Array<UInt8>>.Some(boundary_arr)
        let bufSize=100
        let pNotifier=Option<ProgressNotifier>.None
        let multipartStream=MultipartStream(input,boundary,bufSize,pNotifier)
        let output_s=ByteArrayStream()
        let output=Option<OutputStream>.Some(output_s)
        multipartStream.readBodyData(output)
        @Assert(output_s.readToEnd(),exp_bodydata.toUtf8Array())
    }
}

// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid
// dependence: ../upload_common_values.cj

public let text =
            "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" + "\r\n" + "This is the content of the file\n" + "\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" + "\r\n" + "fieldValue\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value1\r\n" + "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" + "\r\n" + "value2\r\n" + "-----1234--\r\n"
public let exp_header = "-----1234\r\n" + "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" + "Content-Type: text/whatever\r\n" + "\r\n"

@Test
public class TestMultipartStream{
    /***
        public func readHeaders(): String
        测试场景：请求正常。拿到正常的值
    ***/
    @TestCase
    func testMultipartStreamReadHeaders02(): Unit {
        let boundaryString = "-----1234"

        var input = ByteArrayStream()
        input.write(text.toUtf8Array())

        let boundary: Option<Array<UInt8>> = boundaryString.toUtf8Array()

        let notifier = Option<ProgressNotifier>.None

        var multipartStream: MultipartStream = MultipartStream(input, boundary, notifier)

        let re = multipartStream.readHeaders()
        @Assert(re, exp_header)
    }
}
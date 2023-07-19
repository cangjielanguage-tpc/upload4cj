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
public class TestStreams{
    /***
        public static func checkFileName(fileName:Option<String>):Option<String>
        测试场景:fileName非Option<String>.None,且fileName中不包含\u{0}
    ***/
    @TestCase
    func testStreamsCheckFileName03(): Unit {
        let fileName=Option<String>.Some("fileName")
        var re=Streams.checkFileName(fileName)
        @Assert(re.getOrThrow(),fileName.getOrThrow())
    }
}

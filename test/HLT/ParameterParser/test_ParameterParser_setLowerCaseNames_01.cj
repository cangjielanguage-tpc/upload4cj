// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestParameterParser{
    /***
        public init ()
        public func setLowerCaseNames(b: Bool)
        测试场景:单次设置、多次设置
    ***/
    @TestCase
    func testParameterParserSetLowerCaseNames01(): Unit {
        let parameterParser=ParameterParser()
        var isLowerCaseNames=parameterParser.isLowerCaseNames()
        @Assert(isLowerCaseNames,false)
        parameterParser.setLowerCaseNames(true)
        isLowerCaseNames=parameterParser.isLowerCaseNames()
        @Assert(isLowerCaseNames,true)
        parameterParser.setLowerCaseNames(false)
        isLowerCaseNames=parameterParser.isLowerCaseNames()
        @Assert(isLowerCaseNames,false)
    }
}
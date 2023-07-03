// 3rd_party_lib:upload4cj/build/upload4cj
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
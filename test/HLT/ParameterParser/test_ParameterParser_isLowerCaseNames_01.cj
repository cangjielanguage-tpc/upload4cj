// 3rd_party_lib:upload4cj/build/upload4cj
// dependence: ../upload_common_values.cj

@Test
public class TestParameterParser{
    /***
        public init ()
        public func isLowerCaseNames(): Bool
        测试场景:默认值
    ***/
    @TestCase
    func testParameterParserIsLowerCaseNames01(): Unit {
        let parameterParser=ParameterParser()
        let isLowerCaseNames=parameterParser.isLowerCaseNames()
        @Assert(isLowerCaseNames,false)
    }
}
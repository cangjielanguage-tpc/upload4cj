// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestParameterParser{
    /***
        public init ()
        public func parse(charArray: Option<Array<Char>>, offset: Int64, length: Int64, separator: Char): Map<String, Option<String>>
        测试场景:charArray为Option.None
    ***/
    @TestCase
    func testParameterParserParse0101(): Unit {
        let parameterParser=ParameterParser()
        let charArray= Option<Array<Char>>.None
        let re_parse=parameterParser.parse(charArray,121,123,',')
        @Assert(re_parse.size,0)
    }
}
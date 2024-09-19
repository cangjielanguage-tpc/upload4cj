// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj


@Test
public class TestParameterParser{
    /***
        public init ()
        public func parse(charArray: Option<Array<Rune>>, offset: Int64, length: Int64, separator: Rune): Map<String, Option<String>>
        测试场景:charArray非Option.None,但是offset<length不成立
    ***/
    @TestCase
    func testParameterParserParse0102(): Unit {
        let parameterParser=ParameterParser()
        let charArray= Option<Array<Rune>>.Some([r'a',r'b',r'c',r'e'])
        let re_parse=parameterParser.parse(charArray,4,3,r',')
         @Assert(re_parse.size,0)
    }
}

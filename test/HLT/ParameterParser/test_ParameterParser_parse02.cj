// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj


@Test
public class TestParameterParser{
    /***
        public func parse(charArray: Option<Array<Rune>>, separator: Rune): Map<String, Option<String>>
        测试场景:charArray为/非Option.None
    ***/
    @TestCase
    func testParameterParserParse0201(): Unit {
        let parameterParser=ParameterParser()
        let charArray= Option<Array<Rune>>.None
        let re_parse=parameterParser.parse(charArray,r',')
        @Assert(re_parse.size,0)
    }
    @TestCase
    func testParameterParserParse0202(): Unit {
        let parameterParser=ParameterParser()
        let arr_ori=Array<Rune>([r'A',r'B',r'=',r'e',r',',r'e',r'=',r' ',r','])
        let charArray= Option<Array<Rune>>.Some(arr_ori)
        let re_parse=parameterParser.parse(charArray,r',')
        @Assert(re_parse.size,2)
        let ab_value=re_parse.get("AB").getOrThrow().getOrThrow()
        @Assert(ab_value,"e")
        var re_flag=1
        try{
            re_parse.get("e").getOrThrow().getOrThrow()
        }catch(e:NoneValueException){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
}

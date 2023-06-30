// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid
// dependence: ../upload_common_values.cj

@Test
public class TestParameterParser{
    /***
        public func parse(str: Option<String>, separator: Char): Map<String, Option<String>>
        测试场景:str为/非Option.None
    ***/
    @TestCase
    func testParameterParserParse0301(): Unit {
        let parameterParser=ParameterParser()
        let str=Option<String>.None
        let re_parse=parameterParser.parse(str,',')
        @Assert(re_parse.size,0)
    }
    @TestCase
    func testParameterParserParse0302(): Unit {
        let parameterParser=ParameterParser()
        let str_ori="AB=e,e= ,"
        let str= Option<String>.Some(str_ori)
        let re_parse=parameterParser.parse(str,',')
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
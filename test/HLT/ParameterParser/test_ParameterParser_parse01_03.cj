// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// dependence: ../upload_common_values.cj



@Test
public class TestParameterParser{
    /***
        public init ()
        public func parse(charArray: Option<Array<Rune>>, offset: Int64, length: Int64, separator: Rune): Map<String, Option<String>>
        测试场景:charArray非Option.None,但是offset<length成立
    ***/
    @TestCase
    func testParameterParserParse010301(): Unit {
        let parameterParser=ParameterParser()
        let arr_ori=Array<Rune>([r'A',r'B',r'=',r'e',r',',r'e',r'=',r' ',r','])
        let charArray= Option<Array<Rune>>.Some(arr_ori)
        let re_parse=parameterParser.parse(charArray,1,arr_ori.size,r',')
        @Assert(re_parse.size,2)
        let ab_value=re_parse.get("B").getOrThrow().getOrThrow()
        @Assert(ab_value,"e")
        var re_flag=1
        try{
            re_parse.get("e").getOrThrow().getOrThrow()
        }catch(e:NoneValueException){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
    @TestCase
    func testParameterParserParse010302(): Unit {
        let parameterParser=ParameterParser()
        let arr_ori=Array<Rune>([r'A',r'B',r'=',r'e',r'e',r'e',r'=',r' ',r' '])
        let charArray= Option<Array<Rune>>.Some(arr_ori)
        let re_parse=parameterParser.parse(charArray,1,arr_ori.size,r',')
        @Assert(re_parse.size,1)
        var re_flag=1
        try{
            re_parse.get("Bceee").getOrThrow().getOrThrow()
        }catch(e:NoneValueException){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
    @TestCase
    func testParameterParserParse010303(): Unit {
        let parameterParser=ParameterParser()
        let arr_ori=Array<Rune>()
        let charArray= Option<Array<Rune>>.Some(arr_ori)
        var re_flag=1
        try{
            parameterParser.parse(charArray,1,2,r',')
        }catch(e:IndexOutOfBoundsException){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
    @TestCase
    func testParameterParserParse010304(): Unit {
        let parameterParser=ParameterParser()
        parameterParser.setLowerCaseNames(true)
        let arr_ori=Array<Rune>([r'A',r'B',r'=',r'e',r',',r'e',r'=',r' ',r','])
        let charArray= Option<Array<Rune>>.Some(arr_ori)
        let re_parse=parameterParser.parse(charArray,1,arr_ori.size,r',')
        @Assert(re_parse.size,2)
        let ab_value=re_parse.get("b").getOrThrow().getOrThrow()
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

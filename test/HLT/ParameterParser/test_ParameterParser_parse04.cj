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
public class TestParameterParser{
    /***
        public func parse(str: Option<String>, separators: Option<Array<Rune>>): Map<String, Option<String>>
        测试场景:str为/非Option.None,separators为/非Option.None
    ***/
    @TestCase
    func testParameterParserParse0401(): Unit {
        let parameterParser=ParameterParser()
        let str=Option<String>.None
        let separators=Option<Array<Rune>>.None
        let re_parse=parameterParser.parse(str,separators)
        @Assert(re_parse.size,0)
    }
    @TestCase
    func testParameterParserParse0402(): Unit {
        let parameterParser=ParameterParser()
        let str=Option<String>.None
        let separators=Option<Array<Rune>>.Some(Array<Rune>([r'a',r'b',r'c',r'e']))
        let re_parse=parameterParser.parse(str,separators)
        @Assert(re_parse.size,0)
    }
    @TestCase
    func testParameterParserParse0403(): Unit {
        let parameterParser=ParameterParser()
        let str_ori="AB=e,e= ,f=::,"
        let str= Option<String>.Some(str_ori)
        let separators=Option<Array<Rune>>.Some(Array<Rune>([r':',r',']))
        let re_parse=parameterParser.parse(str,separators)
        @Assert(re_parse.size,3)
        let ab_value=re_parse.get("AB").getOrThrow().getOrThrow()
        @Assert(ab_value,"e")
        let f_value=re_parse.get("f").getOrThrow().getOrThrow()
        @Assert(f_value,"::")
        var re_flag=1
        try{
            re_parse.get("e").getOrThrow().getOrThrow()
        }catch(e:NoneValueException){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
    @TestCase
    func testParameterParserParse0404(): Unit {
        let parameterParser=ParameterParser()
        let str_ori="AB=e,e= ,f=::,"
        let str= Option<String>.Some(str_ori)
        let separators=Option<Array<Rune>>.Some(Array<Rune>([r':']))
        let re_parse=parameterParser.parse(str,separators)
        @Assert(re_parse.size,2)
        let ab_value=re_parse.get("AB").getOrThrow().getOrThrow()
        @Assert(ab_value,"e,e= ,f=")
        var re_flag=1
        try{
            re_parse.get(" ").getOrThrow().getOrThrow()
        }catch(e:NoneValueException){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
    @TestCase
    func testParameterParserParse0405(): Unit {
        let parameterParser=ParameterParser()
        let str_ori="AB=e,e= ,f=::,"
        let str= Option<String>.Some(str_ori)
        let separators=Option<Array<Rune>>.Some(Array<Rune>([r',']))
        let re_parse=parameterParser.parse(str,separators)
        @Assert(re_parse.size,3)
        let ab_value=re_parse.get("AB").getOrThrow().getOrThrow()
        @Assert(ab_value,"e")
        let f_value=re_parse.get("f").getOrThrow().getOrThrow()
        @Assert(f_value,"::")
        var re_flag=1
        try{
            re_parse.get("e").getOrThrow().getOrThrow()
        }catch(e:NoneValueException){
            re_flag=0
        }
        @Assert(re_flag,0)
    }
}

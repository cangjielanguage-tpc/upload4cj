// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj

import fuzz.fuzz.*
import upload4cj.*
import std.collection.*

public func fuzzFunc_ParameterParser_parse(dp:DataProvider):Int32 {
    var paramsParser=ParameterParser()
    try{
        paramsParser.parse(Option<Array<Char>>.None,dp.consumeInt64(),dp.consumeInt64(),dp.consumeChar())
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_ParameterParser_parse).startFuzz()
}
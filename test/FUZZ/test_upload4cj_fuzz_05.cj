// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj

import fuzz.fuzz.*
import upload4cj.*
import std.collection.*

public func fuzzFunc_MimeUtility_decodeText(dp:DataProvider):Int32 {
    try{
        MimeUtility.decodeText(dp.consumeString(1024))
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_MimeUtility_decodeText).startFuzz()
}
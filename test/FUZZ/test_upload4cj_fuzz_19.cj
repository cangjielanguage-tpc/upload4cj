// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj

import fuzz.fuzz.*
import upload4cj.*
import std.collection.*

public func fuzzFunc_ProgressNotifier_Init(dp:DataProvider):Int32 {
    try{
        ProgressNotifier(Option<ProgressListener>.None,dp.consumeInt64())
    }catch(e:Exception){}
    return 0
}
main(){
    Fuzzer(fuzzFunc_ProgressNotifier_Init).startFuzz()
}
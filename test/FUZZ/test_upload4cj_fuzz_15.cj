// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj

import fuzz.fuzz.*
import upload4cj.*
import std.collection.*

public func fuzzFunc_FileItemHeadersImpl_addHeader(dp:DataProvider):Int32 {
    var fileItemHeadersImpl=FileItemHeadersImpl()
    try{
        fileItemHeadersImpl.addHeader(dp.consumeString(1000),dp.consumeString(1000))
    }catch(e:Exception){}
    return 0
}
main(){
    Fuzzer(fuzzFunc_FileItemHeadersImpl_addHeader).startFuzz()
}
// 3rd_party_lib:upload4cj/build/upload4cj


import fuzz.fuzz.*
import upload4cj.*
import std.collection.*

public func fuzzFunc_FileItemHeadersImpl_getHeader(dp:DataProvider):Int32 {
    var fileItemHeadersImpl=FileItemHeadersImpl()
    try{
        fileItemHeadersImpl.getHeader(dp.consumeString(1000))
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_FileItemHeadersImpl_getHeader).startFuzz()
}
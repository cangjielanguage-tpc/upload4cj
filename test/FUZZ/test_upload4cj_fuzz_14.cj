// 3rd_party_lib:upload4cj/build/upload4cj


import stdx.fuzz.fuzz.*
import upload4cj.*
import std.collection.*

public func fuzzFunc_FileItemHeadersImpl_getHeaders(dp:DataProvider):Int32 {
    var fileItemHeadersImpl=FileItemHeadersImpl()
    try{
        fileItemHeadersImpl.getHeaders(dp.consumeString(1000))
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_FileItemHeadersImpl_getHeaders).startFuzz()
}
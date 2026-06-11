// 3rd_party_lib:upload4cj/build/upload4cj


import stdx.fuzz.fuzz.*
import cangjie_tpc::upload4cj.*
import std.collection.*

public func fuzzFunc_Streams_copy02(dp:DataProvider):Int32 {
    var fileItemHeadersImpl=FileItemHeadersImpl()
    try{
        fileItemHeadersImpl.getHeader(dp.consumeString(1000))
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_Streams_copy02).startFuzz()
}
// 3rd_party_lib:upload4cj/build/upload4cj


import stdx.fuzz.fuzz.*
import cangjie_tpc::upload4cj.*
import std.collection.*

public func fuzzFunc_MultipartStream_arrayequals(dp:DataProvider):Int32 {
    try{
        MultipartStream.arrayequals(dp.consumeUInt8s(199),dp.consumeUInt8s(199),dp.consumeInt64())
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_MultipartStream_arrayequals).startFuzz()
}
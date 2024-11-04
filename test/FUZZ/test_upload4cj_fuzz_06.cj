// 3rd_party_lib:upload4cj/build/upload4cj


import fuzz.fuzz.*
import upload4cj.*
import std.collection.*
import std.io.*

public func fuzzFunc_MultipartStream_Init(dp:DataProvider):Int32 {
    try{
        MultipartStream(ByteBuffer(),Option<Array<UInt8>>.None,dp.consumeInt64(),Option<ProgressNotifier>.None)
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_MultipartStream_Init).startFuzz()
}
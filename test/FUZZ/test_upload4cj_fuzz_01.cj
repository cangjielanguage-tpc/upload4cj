// 3rd_party_lib:upload4cj/build/upload4cj


import fuzz.fuzz.*
import upload4cj.*
import std.collection.*
import std.fs.*

public func fuzzFunc_DiskFileItem_Init(dp:DataProvider):Int32 {
    try{
        DiskFileItem(dp.consumeString(1024),dp.consumeString(1024),dp.consumeBool(),dp.consumeString(1024),dp.consumeInt64(),Option<Directory>.None)
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_DiskFileItem_Init).startFuzz()
}
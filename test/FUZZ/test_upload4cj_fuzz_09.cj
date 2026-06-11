// 3rd_party_lib:upload4cj/build/upload4cj


import stdx.fuzz.fuzz.*
import cangjie_tpc::upload4cj.*
import std.collection.*
import std.fs.*

public func fuzzFunc_DiskFileItemFactory_Init(dp:DataProvider):Int32 {
    try{
        DiskFileItemFactory(dp.consumeInt64(),Option<Directory>.None)
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_DiskFileItemFactory_Init).startFuzz()
}
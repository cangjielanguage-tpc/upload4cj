// 3rd_party_lib:upload4cj/build/upload4cj


import stdx.fuzz.fuzz.*
import upload4cj.*
import std.collection.*
import std.fs.*

public func fuzzFunc_DiskFileItemFactory_createItem(dp:DataProvider):Int32 {
    let diskFileItemFactory=DiskFileItemFactory(123,Option<Directory>.None)
    try{
        diskFileItemFactory.createItem(dp.consumeString(1000),dp.consumeString(1000),dp.consumeBool(),dp.consumeString(1000))
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_DiskFileItemFactory_createItem).startFuzz()
}
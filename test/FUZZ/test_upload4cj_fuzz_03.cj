// 3rd_party_lib:upload4cj/build/upload4cj


import fuzz.fuzz.*
import upload4cj.*
import std.collection.*
import std.fs.*

public func fuzzFunc_DiskFileItem_setFormField(dp:DataProvider):Int32 {
    let diskfileitem=DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Directory>.None)
    try{
        diskfileitem.setFormField(dp.consumeBool())
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_DiskFileItem_setFormField).startFuzz()
}
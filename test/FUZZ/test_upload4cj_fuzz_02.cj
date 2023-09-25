// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj

from fuzz import fuzz.*
from upload4cj import upload4cj.*
from std import collection.*
from std import fs.*

public func fuzzFunc_DiskFileItem_setFieldName(dp:DataProvider):Int32 {
    let diskfileitem=DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , Option<Directory>.None)
    try{
        diskfileitem.setFieldName(dp.consumeString(1024))
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_DiskFileItem_setFieldName).startFuzz()
}
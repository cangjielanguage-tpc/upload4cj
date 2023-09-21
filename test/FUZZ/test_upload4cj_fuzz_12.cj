// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj

from fuzz import fuzz.*
from upload4cj import upload4cj.*
from std import collection.*
from std import fs.*

public func fuzzFunc_DiskFileItemFactory_setDefaultCharset(dp:DataProvider):Int32 {
    let diskFileItemFactory=DiskFileItemFactory(123,Option<Directory>.None)
    try{
        diskFileItemFactory.setDefaultCharset(dp.consumeString(1000))
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_DiskFileItemFactory_setDefaultCharset).startFuzz()
}
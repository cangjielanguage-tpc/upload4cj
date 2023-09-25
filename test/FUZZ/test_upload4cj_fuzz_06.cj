// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj

from fuzz import fuzz.*
from upload4cj import upload4cj.*
from std import collection.*
from std import io.*

public func fuzzFunc_MultipartStream_Init(dp:DataProvider):Int32 {
    try{
        MultipartStream(ByteArrayStream(),Option<Array<UInt8>>.None,dp.consumeInt64(),Option<ProgressNotifier>.None)
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_MultipartStream_Init).startFuzz()
}
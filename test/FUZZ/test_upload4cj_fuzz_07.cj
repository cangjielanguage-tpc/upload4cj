// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj

import fuzz.fuzz.*
import upload4cj.*
import std.collection.*
import std.io.*

public func fuzzFunc_MultipartStream_setBoundary(dp:DataProvider):Int32 {
    var boundary_arr="8888888888".toArray()
    let mutil=MultipartStream(ByteArrayStream(),Option<Array<UInt8>>.Some(boundary_arr),1024,Option<ProgressNotifier>.None)
    try{
        mutil.setBoundary(dp.consumeString(1000).toArray())
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_MultipartStream_setBoundary).startFuzz()
}

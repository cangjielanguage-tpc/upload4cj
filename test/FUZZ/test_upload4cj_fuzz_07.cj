// 3rd_party_lib:upload4cj/build/upload4cj


import stdx.fuzz.fuzz.*
import cangjie_tpc::upload4cj.*
import std.collection.*
import std.io.*

public func fuzzFunc_MultipartStream_setBoundary(dp:DataProvider):Int32 {
    var boundary_arr="8888888888".toArray()
    let mutil=MultipartStream(ByteBuffer(),Option<Array<UInt8>>.Some(boundary_arr),1024,Option<ProgressNotifier>.None)
    try{
        mutil.setBoundary(dp.consumeString(1000).toArray())
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_MultipartStream_setBoundary).startFuzz()
}

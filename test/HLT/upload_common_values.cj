// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj

from std import unittest.*
from std import unittest.testmacro.*
from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import math.*
from std import collection.*
from net import http.*

public func getRepository(path:String):Option<Directory>{
    var repository=Option<Directory>.None
    try{
        let dic=Directory.create(path)
        repository=Option<Directory>.Some(dic)
    }catch(e:FSException){
        let dic=Directory(path)
        repository=Option<Directory>.Some(dic)
    }
    return repository
}

public class SubLimitedInputStream <: LimitedInputStream{
    public init(inputStream: InputStream, pSizeMax: Int64) {
        super(inputStream,pSizeMax)
    }
    protected func raiseError(pSizeMax: Int64, pCount: Int64): Unit{
		println(pSizeMax)
		println(pCount)
		throw IOException("raiseError")
    }
}

public class SubThresholdingOutputStream<:ThresholdingOutputStream & InputStream{
    public var buf=Array<UInt8>()
    public var pos=0
    public var count=0
    public var mark=0
    public init(threshold:Int64,buf:Array<UInt8>, offset:Int64, length:Int64) {
        super(threshold)
        this.buf = buf
        this.pos = offset
        this.count = min(offset + length, buf.size);
        this.mark = offset
    }
    public func read(target: Array<UInt8>):Int64 {
        if(this.pos < this.count){
            buf.copyTo(target, pos,0, count)
            return Int64(this.buf[pos] & 0xff)
        }else{
             return -1
        }
    }
    public func readToEnd():Array<UInt8> {
        var result=Array<UInt8>()
        buf.copyTo(result, pos,0, count);
        pos = count;
        return result;
    }
    protected func getStream(): OutputStream{
        let byte=ByteArrayStream()
        byte.write("origin".toUtf8Array())
        return byte
    }
    protected func thresholdReached(): Unit{}
}

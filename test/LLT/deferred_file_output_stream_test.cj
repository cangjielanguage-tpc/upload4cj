// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from upload4cj import upload4cj.*
from std import unittest.*
from std import unittest.testmacro.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

main(){
    let deferredFileOutputStream = DeferredFileOutputStreamTest()
    deferredFileOutputStream.test1()
    deferredFileOutputStream.test2()
    return 0
}


@Test
public class DeferredFileOutputStreamTest{

    @TestCase
    public func test1(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp1")
        let file = File(filePath,OpenOption.Create(true))
        if(!File.exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Directory>.None)

        let textFieldValue:String = "0123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toUtf8Array()
        dfos.write(testFieldValueBytes)
        let isInMemory = dfos.isInMemory()
        @Assert(isInMemory,true)
        let strData:String = String.fromUtf8(dfos.getData().getOrThrow())
        @Assert(strData,textFieldValue)
        let threshold:Int64 = dfos.getThreshold()
        @Assert(threshold,sizeThreshold)
        let writtenByteCount:Int64 = dfos.getByteCount()
        @Assert(writtenByteCount,textFieldValue.size)
        let isExceeded:Bool = dfos.isThresholdExceeded()
        @Assert(isExceeded,false)
        dfos.flush()
        dfos.close()
        println("Pass1")
    }

     @TestCase
    public func test2(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp2")
        let file = File(filePath,OpenOption.Create(true))
        if(!File.exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Directory>.None)

        let textFieldValue:String = "01234567890123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toUtf8Array()
        dfos.write(testFieldValueBytes)
        let isInMemory = dfos.isInMemory()
        @Assert(isInMemory,false)
        var isNull= false
        if(let Some(i) = dfos.getData()){
            isNull = false
        }else{
            isNull = true
        }
        @Assert(isNull,true)
        let size = dfos.getFile().getOrThrow().info.length
        @Assert(size,20)
        let threshold:Int64 = dfos.getThreshold()
        @Assert(threshold,sizeThreshold)
        let writtenByteCount:Int64 = dfos.getByteCount()
        @Assert(writtenByteCount,textFieldValue.size)
        let isExceeded:Bool = dfos.isThresholdExceeded()
        @Assert(isExceeded,true)
        dfos.flush()
        dfos.close()
        println("Pass2")
    }
}

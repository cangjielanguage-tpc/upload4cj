// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import cangjie_tpc::upload4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import std.fs.*
import std.io.*
import std.collection.*
import stdx.net.http.*

main(){
    let deferredFileOutputStream = DeferredFileOutputStreamTest()
    deferredFileOutputStream.test1()
    deferredFileOutputStream.test2()
    deferredFileOutputStream.test3()
    deferredFileOutputStream.test4()
    deferredFileOutputStream.test5()
    deferredFileOutputStream.test6()
    deferredFileOutputStream.test7()
    deferredFileOutputStream.test8()
    deferredFileOutputStream.test9()
    deferredFileOutputStream.test10()
    deferredFileOutputStream.test11()

    return 0
}


@Test
public class DeferredFileOutputStreamTest{

    @TestCase
    public func test1(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp1")
        let file = File.create(filePath)
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Path>.None)
        let textFieldValue:String = "0123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        dfos.write(testFieldValueBytes)
        let isInMemory = dfos.isInMemory()
        @Assert(isInMemory,true)
        dfos.flush()
        dfos.close()
        println("Pass1")
    }

    @TestCase
    public func test2(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp2")
        let file = File.create(filePath)
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Path>.None)
        let textFieldValue:String = "0123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        dfos.write(testFieldValueBytes)
        let strData:String = String.fromUtf8(dfos.getData().getOrThrow())
        @Assert(strData,textFieldValue)
        dfos.flush()
        dfos.close()
        println("Pass2")
    }


       @TestCase
    public func test3(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp3")
        let file = File.create(filePath)
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Path>.None)
        let textFieldValue:String = "0123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        dfos.write(testFieldValueBytes)
        let threshold:Int64 = dfos.getThreshold()
        @Assert(threshold,sizeThreshold)
        dfos.flush()
        dfos.close()
        println("Pass3")
    }

           @TestCase
    public func test4(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp4")
        let file = File.create(filePath)
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Path>.None)
        let textFieldValue:String = "0123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        dfos.write(testFieldValueBytes)
        let writtenByteCount:Int64 = dfos.getByteCount()
        @Assert(writtenByteCount,textFieldValue.size)
        dfos.flush()
        dfos.close()
        println("Pass4")
    }

           @TestCase
    public func test5(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp5")
        let file = File.create(filePath)
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Path>.None)
        let textFieldValue:String = "0123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        dfos.write(testFieldValueBytes)
        let isExceeded:Bool = dfos.isThresholdExceeded()
        @Assert(isExceeded,false)
        dfos.flush()
        dfos.close()
        println("Pass5")
    }

     @TestCase
    public func test6(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp6")
        let file = File.create(filePath)
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Path>.None)
        let textFieldValue:String = "01234567890123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        dfos.write(testFieldValueBytes)
        let isInMemory = dfos.isInMemory()
        @Assert(isInMemory,false)
        dfos.flush()
        dfos.close()
        println("Pass6")
    }

        @TestCase
    public func test7(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp7")
        let file = File.create(filePath)
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Path>.None)
        let textFieldValue:String = "01234567890123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        dfos.write(testFieldValueBytes)
        var isNull= false
        if(let Some(_) <- dfos.getData()){
            isNull = false
        }else{
            isNull = true
        }
        @Assert(isNull,true)
        dfos.flush()
        dfos.close()
        println("Pass7")
    }

        @TestCase
    public func test8(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp8")
        let file = File.create(filePath)
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Path>.None)
        let textFieldValue:String = "01234567890123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        dfos.write(testFieldValueBytes)
        let size = dfos.getFile().getOrThrow().info.size
        @Assert(size,20)
        dfos.flush()
        dfos.close()
        println("Pass8")
    }

        @TestCase
    public func test9(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp9")
        let file = File.create(filePath)
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Path>.None)
        let textFieldValue:String = "01234567890123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        dfos.write(testFieldValueBytes)
        let threshold:Int64 = dfos.getThreshold()
        @Assert(threshold,sizeThreshold)
        dfos.flush()
        dfos.close()
        println("Pass9")
    }

        @TestCase
    public func test10(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp10")
        let file = File.create(filePath)
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Path>.None)
        let textFieldValue:String = "01234567890123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        dfos.write(testFieldValueBytes)
        let writtenByteCount:Int64 = dfos.getByteCount()
        @Assert(writtenByteCount,textFieldValue.size)
        dfos.flush()
        dfos.close()
        println("Pass10")
    }

        @TestCase
    public func test11(): Unit {
        var sizeThreshold:Int64 = 16
        let filePath:Path = Path("./deffertemp11")
        let file = File.create(filePath)
        if(!exists(file.info.path)){
            File.create(file.info.path)
        }
        let dfos:DeferredFileOutputStream = DeferredFileOutputStream(sizeThreshold, Option<File>.None,Option<Path>.None)
        let textFieldValue:String = "01234567890123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        dfos.write(testFieldValueBytes)
        let isExceeded:Bool = dfos.isThresholdExceeded()
        @Assert(isExceeded,true)
        dfos.flush()
        dfos.close()
        println("Pass11")
    }
}

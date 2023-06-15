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
    let limitedInputStream = LimitIntputStreamTest()
    limitedInputStream.test1()
    return 0
}


@Test
public class LimitIntputStreamTest{

    @TestCase
    public func test1(): Unit {
        let filePath:Path = Path("./limitedtemp")
        let file = File(filePath,OpenOption.Create(true))
        if(!File.exists(file.info.path)){
            File.create(file.info.path)
        }
        let content = "01234567890123456789"
        file.write(content.toUtf8Array())
        file.seek(SeekPosition.Begin(0))
        let pMax:Int64 = 10
        let limitInputStream = LimitedInputStreamImpl(file,pMax)
        let bytesArray:Array<UInt8> = Array<UInt8>(20,item:0)
        var isExpected:Bool = false
        try{
            let res:Int64 = limitInputStream.read(bytesArray)
        }catch(e:SizeLimitExceededException){
            isExpected = true
        }
        @Assert(isExpected,true)
        println("Pass1")
    }

}

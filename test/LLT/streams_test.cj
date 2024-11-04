// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import upload4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

main(){
    let streamsTest = StreamsTest()
    streamsTest.test1()
    streamsTest.test2()
    return 0
}


@Test
public class StreamsTest{

    @TestCase
    public func test1(): Unit {
         let filePathInput:Path = Path("./streamtestinputtemp")
         let fileIn = File(filePathInput,OpenOption.Create(true))
         if(!exists(fileIn.info.path)){
            File.create(fileIn.info.path)
         }
         let content = "01234567890123456789"
         fileIn.write(content.toArray())
         fileIn.seek(SeekPosition.Begin(0))

        let filePathOutput:Path = Path("./streamtestoutputtemp")
        let fileOut = File(filePathOutput,OpenOption.Create(true))
        if(!exists(fileOut.info.path)){
            File.create(fileOut.info.path)
        }
        Streams.copy(fileIn,fileOut,true)
        fileOut.seek(SeekPosition.Begin(0))
        let bytesArray:Array<UInt8> = Array<UInt8>(20,repeat:0)
        fileOut.read(bytesArray)
        @Assert(String.fromUtf8(bytesArray),content)
        println("Pass1")
    }

    @TestCase
    public func test2(): Unit {
        let fileName = "foo.exe\u{0}.png"
        var expected = false
        try{
            Streams.checkFileName(fileName)
        }catch(e:InvalidFileNameException){
            expected = true
        }
        @Assert(expected,true)
        println("Pass2")
    }

}

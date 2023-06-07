// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from upload4cj import upload4cj.*
from std import unittest.*
from std import unittest.testmacro.*
from std import fs.*

main(){
    let diskFileItemTest = DiskFileItemTest()
    diskFileItemTest.test1()
    diskFileItemTest.test2()
    return 0
}


@Test
public class DiskFileItemTest {

    public static let threshold:Int64 = 16
    public static let textContentType:String = "text/plain"

    @TestCase
    public func test1(): Unit {
        let factory:FileItemFactory = createFactory(Option<Directory>.None)
        let textFieldName:String = "textField"
        let item:FileItem = factory.createItem(textFieldName,textContentType,true,"")

        @Assert(item.getFieldName(),textFieldName)
        @Assert(item.getContentType(),textContentType)
        @Assert(item.isGetFormField(),true)
        @Assert(item.getName(),"")
        println("Pass1")
    }


    @TestCase
    public func test2(): Unit {
        let factory:FileItemFactory = createFactory(Option<Directory>.None)
        let textFieldName:String = "textField"
        let textFieldValue:String = "0123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toUtf8Array()

        let item:FileItem = factory.createItem(textFieldName,textContentType,true,"")

        let output = item.getOutputStream()
        output.write(testFieldValueBytes)


        @Assert(item.isInMemory(),true)
        @Assert(item.getSize(),testFieldValueBytes.size)
        @Assert(item.get().getOrThrow().size,testFieldValueBytes.size)
        @Assert(item.getString(),textFieldValue)
        println("Pass2")
    }

    public func createFactory(repository:Option<Directory>):FileItemFactory{
        return DiskFileItemFactory(threshold,repository)
    }




}

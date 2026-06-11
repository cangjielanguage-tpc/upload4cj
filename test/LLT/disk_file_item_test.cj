// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import cangjie_tpc::upload4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import std.fs.*
import std.io.*
import std.collection.*
import std.posix.*

main(){
    let diskFileItemTest = DiskFileItemTest()
    diskFileItemTest.test1()
    diskFileItemTest.test2()
    diskFileItemTest.test3()
    diskFileItemTest.test4()
    diskFileItemTest.test5()
    diskFileItemTest.test6()
    return 0
}


@Test
public class DiskFileItemTest {

    public static let threshold:Int64 = 16
    public static let textContentType:String = "text/plain"
    public static let fileContentType:String = "application/octet-stream"

    @TestCase
    public func test1(): Unit {
        let factory:FileItemFactory = createFactory(Option<Path>.None)
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
        let factory:FileItemFactory = createFactory(Option<Path>.None)
        let fileFieldName:String = "fileField"
        let fileName:String = "originalFileName";

        let item:FileItem = factory.createItem(fileFieldName,fileContentType,false,fileName)

        @Assert(item.getFieldName(),fileFieldName)
        @Assert(item.getContentType(),fileContentType)
        @Assert(item.isGetFormField(),false)
        @Assert(item.getName(),fileName)
        println("Pass2")
    }

    @TestCase
    public func test3(): Unit {
        let factory:FileItemFactory = createFactory(Option<Path>.None)
        let textFieldName:String = "textField"
        let textFieldValue:String = "0123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()

        let item:FileItem = factory.createItem(textFieldName,textContentType,true,"")

        let output = item.getOutputStream()
        output.write(testFieldValueBytes)
        item.getInputStream()
        @Assert(item.isInMemory(),true)
        @Assert(item.getSize(),testFieldValueBytes.size)
        @Assert(item.get().getOrThrow().size,testFieldValueBytes.size)
        @Assert(item.getString(),textFieldValue)
        println("Pass3")
    }


    @TestCase
    public func test4(): Unit {
        var path: String = getcwd()
        var dir = Path(path + "/tmpDir")
        Directory.create(dir)
        let factory:FileItemFactory = createFactory(dir)
        let textFieldName:String = "textField"
        let textFieldValue:String = "01234567890123456789"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()

        let item:FileItem = factory.createItem(textFieldName,textContentType,true,"")

        let output = item.getOutputStream()
        output.write(testFieldValueBytes)
        item.getInputStream()
        @Assert(item.isInMemory(),false)
        @Assert(item.getSize(),testFieldValueBytes.size)
        @Assert(item.get().getOrThrow().size,testFieldValueBytes.size)
        @Assert(item.getString(),textFieldValue)

        let diskFileItem = item as DiskFileItem
        if(let Some(i) <- diskFileItem){
            //i就是diskFileItem
            let file:Option<File> = i.getStoreLocation()
            var isFileExists = false
            if(let Some(_) <- file){
                isFileExists = true
            }else{
                isFileExists = false
            }
            @Assert(isFileExists,true)

            @Assert(exists(file.getOrThrow().info.path),true)

            @Assert(file.getOrThrow().info.size,testFieldValueBytes.size)

            @Assert(file.getOrThrow().info.parentDirectory.getOrThrow().path.toString(),dir.toString())
            println(i.toString())
            println("Pass4-1")
        }

        item.delete()
        println("Pass4-2")

    }

    public func createFactory(repository:Option<Path>):FileItemFactory{
        return DiskFileItemFactory(threshold,repository)
    }

    public static let SWISS_GERMAN_STUFF_UTF8:Array<UInt32> = [ 0x47, 0x72, 0xC3, 0xBC, 0x65, 0x7A, 0x69, 0x5F, 0x7A, 0xC3, 0xA4, 0x6D, 0xC3, 0xA4 ]
    public static let SWISS_GERMAN_STUFF_UNICODE:Array<UInt32> = [ 0x47, 0x72, 0xFC, 0x65, 0x7A, 0x69, 0x5F, 0x7A, 0xE4, 0x6D, 0xE4 ]

    public static let CHARSET_UTF8:String = "UTF-8"

    public func constructString():String{
        let buffer:StringBuilder = StringBuilder()
        for(i in 0..SWISS_GERMAN_STUFF_UTF8.size){
            buffer.append(Rune(SWISS_GERMAN_STUFF_UTF8[i]))
        }
        return buffer.toString()
    }

    @TestCase
    public func test5(): Unit {

        let factory:FileItemFactory = createFactory(Option<Path>.None)
        let teststr:String = constructString()
        let item:FileItem = factory.createItem("doesnotmatter","text/plain; charset=" + CHARSET_UTF8,true,"")
        let outstream:OutputStream = item.getOutputStream()
        let str2 = constructString()
        outstream.write(str2.toArray())
        @Assert(teststr,item.getString())
        println("Pass5")
    }



    @TestCase
    public func test6(): Unit {
        let factory:FileItemFactory = createFactory(Option<Path>.None)
        let textFieldName:String = ""
        let textFieldValue:String = "0123456789"
        let newtextContentType = "text/plain; Charset=UTF-8"
        let testFieldValueBytes:Array<UInt8> = textFieldValue.toArray()
        let item:FileItem = factory.createItem(textFieldName,newtextContentType,false,"")
        item.setFieldName("textField")
        item.setFormField(true)
        let output = item.getOutputStream()
        output.write(testFieldValueBytes)

        @Assert(item.getFieldName(),"textField")
        @Assert(item.getContentType(),newtextContentType)
        @Assert(item.isGetFormField(),true)
        @Assert(item.getName(),"")

        let diskFileItem = item as DiskFileItem
        if(let Some(i) <- diskFileItem){
            i.setDefaultCharset("UTF-8")
            @Assert(i.getDefaultCharset(),"UTF-8")
            @Assert(i.getCharSet(),"UTF-8")
            println(i.toString())
            println("Pass6-1")
        }
        println("Pass6-2")
    }




}

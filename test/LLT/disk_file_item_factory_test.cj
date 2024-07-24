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
    let diskFileItemFactoryTest = DiskFileItemFactoryTest()
    diskFileItemFactoryTest.test1()
    diskFileItemFactoryTest.test2()
    diskFileItemFactoryTest.test3()

    return 0
}


@Test
public class DiskFileItemFactoryTest{

    @TestCase
    public func test1(): Unit {

        let factory:DiskFileItemFactory = DiskFileItemFactory()
        factory.setDefaultCharset("UTF-8")
        @Assert(factory.getDefaultCharset(),"UTF-8")
        println("Pass1")

    }

     @TestCase
    public func test2(): Unit {

        let factory:DiskFileItemFactory = DiskFileItemFactory()
        factory.setSizeThreshold(1024)
        @Assert(factory.getSizeThreshold(),1024)
        println("Pass2")

    }

     @TestCase
    public func test3(): Unit {

        let factory:DiskFileItemFactory = DiskFileItemFactory()
        factory.setDefaultCharset("UTF-8")
        factory.setSizeThreshold(1024)
        let dirPath:Path = Path("./dirfactory")
        var dir:Option<Directory> = Option<Directory>.None
        if(!Directory.exists(dirPath)){
            dir = Directory.create(dirPath)
        }
        factory.setRepository(dir)
        let dirget:Directory = factory.getRepository().getOrThrow()
        let isexists:Bool = Directory.exists(dirget.info.path)
        @Assert(isexists,true)

        Directory.delete(dirget.info.path)

        println("Pass3")

    }

}

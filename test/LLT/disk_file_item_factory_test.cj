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
    let diskFileItemFactoryTest = DiskFileItemFactoryTest()
    diskFileItemFactoryTest.test1()
    return 0
}


@Test
public class DiskFileItemFactoryTest{

    @TestCase
    public func test1(): Unit {

        let factory:DiskFileItemFactory = DiskFileItemFactory()
        factory.setDefaultCharset("UTF-8")
        factory.setSizeThreshold(1024)
        let dirPath:Path = Path("./dirfactory")
        var dir:Option<Directory> = Option<Directory>.None
        if(!Directory.exists(dirPath)){
            dir = Directory.create(dirPath)
        }
        factory.setRepository(dir)

        @Assert(factory.getDefaultCharset(),"UTF-8")
        @Assert(factory.getSizeThreshold(),1024)

        let dirget:Directory = factory.getRepository().getOrThrow()
        let isexists:Bool = Directory.exists(dirget.info.path)
        @Assert(isexists,true)

        Directory.delete(dirget.info.path)

        println("Pass1")

    }

}

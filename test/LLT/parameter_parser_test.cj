
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from upload4cj import upload4cj.*
from std import unittest.*
from std import unittest.testmacro.*
from std import collection.*

main(){
    let parameterTest = parameterTest()
    parameterTest.test1()
    parameterTest.test2()
    parameterTest.test3()
    parameterTest.test4()
    parameterTest.test5()
    parameterTest.test6()
    parameterTest.test7()
    parameterTest.test8()
    parameterTest.test9()
    parameterTest.test10()
    parameterTest.test11()
    return 0
}

@Test
public class parameterTest {
    
    @TestCase
    public func test1(): Unit {
        let s: String = "test; test1 =  stuff   ; test2 =  \"stuff; stuff\"; test3=\"stuff"
        var parser: ParameterParser = ParameterParser()
        let s1: Option<String> = s
        var map: Map<String, Option<String>> = parser.parse(s1, ';')

        let isTest: Bool = match(map.get("test").getOrThrow()) {
            case None =>
                false
            case Some(v) =>
                true
        }

        @Assert(isTest, false)

        @Assert(map.get("test1").getOrThrow().getOrThrow(), "stuff")
        @Assert(map.get("test2").getOrThrow().getOrThrow(), "stuff; stuff")
        @Assert(map.get("test3").getOrThrow().getOrThrow(), "\"stuff")

        println("Pass1")
    }

    @TestCase
    public func test2(): Unit {
        let s: String = "test; test1 =  stuff   ; test2 =  \"stuff; stuff\"; test3=\"stuff"
        var parser: ParameterParser = ParameterParser()
        let s1: Option<String> = s
        var arrayChar: Option<Array<Char>> = [',', ';']
        var map: Map<String, Option<String>> = parser.parse(s1, arrayChar)

        let isTest: Bool = match(map.get("test").getOrThrow()) {
            case None =>
                false
            case Some(v) =>
                true
        }

        @Assert(isTest, false)

        @Assert(map.get("test1").getOrThrow().getOrThrow(), "stuff")
        @Assert(map.get("test2").getOrThrow().getOrThrow(), "stuff; stuff")
        @Assert(map.get("test3").getOrThrow().getOrThrow(), "\"stuff")

        println("Pass2")
    }

    @TestCase
    public func test3(): Unit {
        let s: String = "  test  , test1=stuff   ,  , test2=, test3, "
        var parser: ParameterParser = ParameterParser()
        let s1: Option<String> = s
        var map: Map<String, Option<String>> = parser.parse(s1, ',')

        let isTest: Bool = match(map.get("test").getOrThrow()) {
            case None =>
                false
            case Some(v) =>
                true
        }

        let isTest2: Bool = match(map.get("test2").getOrThrow()) {
            case None =>
                false
            case Some(v) =>
                true
        }

        let isTest3: Bool = match(map.get("test3").getOrThrow()) {
            case None =>
                false
            case Some(v) =>
                true
        }

        @Assert(isTest, false)
        @Assert(isTest2, false)
        @Assert(isTest3, false)
        @Assert(map.get("test1").getOrThrow().getOrThrow(), "stuff")

        println("Pass3")
    }

    @TestCase
    public func test4(): Unit {
        let s: String = "  test"
        var parser: ParameterParser = ParameterParser()
        let s1: Option<String> = s
        var map: Map<String, Option<String>> = parser.parse(s1, ';')

        let isTest: Bool = match(map.get("test").getOrThrow()) {
            case None =>
                false
            case Some(v) =>
                true
        }

        @Assert(isTest, false)
        println("Pass4")
    }

    @TestCase
    public func test5(): Unit {
        let s: String = "  "
        var parser: ParameterParser = ParameterParser()
        let s1: Option<String> = s
        var map: Map<String, Option<String>> = parser.parse(s1, ';')

        @Assert(map.size, 0)

        println("Pass5")
    }

    @TestCase
    public func test6(): Unit {
        let s: String = " = stuff "
        var parser: ParameterParser = ParameterParser()
        let s1: Option<String> = s
        var map: Map<String, Option<String>> = parser.parse(s1, ';')

        @Assert(map.size, 0)

        println("Pass6")
    }

    @TestCase
    public func test7(): Unit {
        let s: String = "text/plain; Charset=UTF-8"
        var parser: ParameterParser = ParameterParser()
        parser.setLowerCaseNames(true)
        let isLowerCaseNames: Bool = parser.isLowerCaseNames()
        let s1: Option<String> = s
        var map: Map<String, Option<String>> = parser.parse(s1, ';')
        @Assert(isLowerCaseNames, true)
        @Assert(map.get("charset").getOrThrow().getOrThrow(), "UTF-8")
        println("Pass7")
    }

    @TestCase
    public func test8(): Unit {
        let s: String = "param = \"stuff\\\"; more stuff\""
        var parser: ParameterParser = ParameterParser()
        let s1: Option<String> = s
        
        var map: Map<String, Option<String>> = parser.parse(s1, ';')

        @Assert(map.size, 1)
        @Assert(map.get("param").getOrThrow().getOrThrow(), "stuff\\\"; more stuff")

        println("Pass8")
    }

    @TestCase
    public func test9(): Unit {
        let s: String = "param = \"stuff\\\\\"; anotherparam"
        var parser: ParameterParser = ParameterParser()
        let s1: Option<String> = s
        
        var map: Map<String, Option<String>> = parser.parse(s1, ';')

        @Assert(map.size, 2)
        @Assert(map.get("param").getOrThrow().getOrThrow(), "stuff\\\\")

        let isTest: Bool = match(map.get("anotherparam").getOrThrow()) {
            case None =>
                false
            case Some(v) =>
                true
        }

        @Assert(isTest, false)

        println("Pass9")
    }

    @TestCase
    public func test10(): Unit {
        let parser: ParameterParser = ParameterParser()

        let s: Option<String> = "Content-type: multipart/form-data , boundary=AaB03x"
        let s_new: Option<String> = "Content-type: multipart/form-data, boundary=AaB03x"
        
        var arrayChar: Option<Array<Char>> = [',', ';']
        var arrayChar_new: Option<Array<Char>> = [';', ',']

        var map: Map<String, Option<String>> = parser.parse(s, arrayChar)
        var map_new: Map<String, Option<String>> = parser.parse(s_new, arrayChar_new)
        
        @Assert(map.get("boundary").getOrThrow().getOrThrow(), "AaB03x")
        @Assert(map_new.get("boundary").getOrThrow().getOrThrow(), "AaB03x")
   
        let s2: Option<String> = "Content-type: multipart/mixed, boundary=BbC04y"
        var arrayChar2: Option<Array<Char>> = [',', ';']
        var map2: Map<String, Option<String>> = parser.parse(s2, arrayChar2)

        @Assert(map2.get("boundary").getOrThrow().getOrThrow(), "BbC04y")

        println("Pass10")
    }

    @TestCase
    public func test11(): Unit {
        let parser: ParameterParser = ParameterParser()

        let s: Option<String> = "Content-Disposition: form-data; name=\"file\"; filename=\"=?UTF-8?B?SWYgeW91IGNhbiByZWFkIHRoaXMgeW8=?= =?UTF-8?B?dSB1bmRlcnN0YW5kIHRoZSBleGFtcGxlLg==?=\"\r\n";

        var arrayChar: Option<Array<Char>> = [',', ';']

        var map: Map<String, Option<String>> = parser.parse(s, arrayChar)

        @Assert(map.get("filename").getOrThrow().getOrThrow(), "If you can read this you understand the example.")
        println("Pass11")
    }
}
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::upload4cj.*
import std.io.*
import stdx.encoding.base64.*
import stdx.encoding.hex.*
import std.sync.*
import std.collection.*
import std.convert.*
import std.unittest.*
import std.unittest.testmacro.*

main() {
    let mimeUtilityTest = MimeUtilityTest()
    mimeUtilityTest.test1()
    mimeUtilityTest.test2()
    mimeUtilityTest.test3()
    mimeUtilityTest.test4()
    mimeUtilityTest.test5()
    mimeUtilityTest.test6()
    mimeUtilityTest.test7()
    mimeUtilityTest.test8()
    mimeUtilityTest.test9()
    mimeUtilityTest.test10()
    mimeUtilityTest.test11()
    mimeUtilityTest.test12()
    return 0
}

@Test
public class MimeUtilityTest {
    @TestCase
    public func test1(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText("abc")
        let expected: Option<String> = "abc"
        @Assert(expected.getOrThrow(), encoded.getOrThrow())

        println("Pass1")
    }

    @TestCase
    public func test10(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText("abc-rf")
        let expected: Option<String> = "abc-rf"
        @Assert(expected.getOrThrow(), encoded.getOrThrow())

        println("Pass10")
    }

    @TestCase
    public func test11(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText("abc-rf_ty")
        let expected: Option<String> = "abc-rf_ty"
        @Assert(expected.getOrThrow(), encoded.getOrThrow())

        println("Pass11")
    }

    @TestCase
    public func test12(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText("abc-rf_ty:56")
        let expected: Option<String> = "abc-rf_ty:56"
        @Assert(expected.getOrThrow(), encoded.getOrThrow())

        println("Pass12")
    }

    @TestCase
    public func test2(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText(
            "=?ISO-8859-1?B?SWYgeW91IGNhbiByZWFkIHRoaXMgeW8=?= =?ISO-8859-2?B?dSB1bmRlcnN0YW5kIHRoZSBleGFtcGxlLg==?=")
        let expected: Option<String> = "If you can read this you understand the example."
        @Assert(expected.getOrThrow(), encoded.getOrThrow())

        println("Pass2")
    }

    @TestCase
    public func test3(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText(
            "=?ISO-8859-1?B?SWYgeW91IGNhbiByZWFkIHRoaXMgeW8=?=\t  \r\n   =?ISO-8859-2?B?dSB1bmRlcnN0YW5kIHRoZSBleGFtcGxlLg==?=\"\r\n"
        )
        let expected: Option<String> = "If you can read this you understand the example."
        @Assert(expected.getOrThrow(), encoded.getOrThrow())

        println("Pass3")
    }

    @TestCase
    public func test4(): Unit {
        try {
            MimeUtility.decodeText("=?invalid?B?xyz-?=")
        } catch (e: UnsupportedEncodingException) {
            if (e.toString().contains("Invalid RFC 2047 encoding")) {
                println("Pass4")
            }
        }
    }

    @TestCase
    public func test5(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText("=??=")
        @Assert(encoded.getOrThrow(), "=??=")
        println("Pass5")
    }

    @TestCase
    public func test7(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText("=?")
        @Assert(encoded.getOrThrow(), "=?")
        println("Pass7")
    }

    @TestCase
    public func test6(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText("=?UTF-8?Q?_h=C3=A9!_=C3=A0=C3=A8=C3=B4u_!!!?=")
        let expected = " hé! àèôu !!!"
        @Assert(encoded.getOrThrow(), expected)
        println("Pass6")
    }

    @TestCase
    public func test9(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText("=?UTF-8?B?IGjDqSEgw6DDqMO0dSAhISE=?=")
        let expected = " hé! àèôu !!!"
        @Assert(encoded.getOrThrow(), expected)
        println("Pass9")
    }

    @TestCase
    public func test8(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText("")
        @Assert(encoded.getOrThrow(), "")
        println("Pass8")
    }
}

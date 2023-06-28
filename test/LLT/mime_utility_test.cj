// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
from upload4cj import upload4cj.*
from std import io.*
from encoding import base64.*
from encoding import hex.*
from std import sync.*
from std import collection.*
from std import convert.*
from std import unittest.*
from std import unittest.testmacro.*

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
            let encoded: Option<String> = MimeUtility.decodeText("=?invalid?B?xyz-?=")
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
    public func test8(): Unit {
        let encoded: Option<String> = MimeUtility.decodeText("")
        @Assert(encoded.getOrThrow(), "")
        println("Pass8")
    }
}

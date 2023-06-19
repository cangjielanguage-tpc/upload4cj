// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
from upload4cj import upload4cj.*
from std import unittest.*
from std import unittest.testmacro.*

main() {
    let mimeUtilityTest = MimeUtilityTest()
    mimeUtilityTest.test1()
    mimeUtilityTest.test2()
    mimeUtilityTest.test3()
    mimeUtilityTest.test4()
    mimeUtilityTest.test5()
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
        try {
            let encoded: Option<String> = MimeUtility.decodeText("=??=")
        } catch (e: ParseException) {
            if (e.toString().contains("Decode This Text Fail")) {
                println("Pass5")
            }
        }
    }
}

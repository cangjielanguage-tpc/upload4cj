// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
from upload4cj import upload4cj.*
from std import unittest.*
from std import unittest.testmacro.*
from std import io.*
from encoding import base64.*
from encoding import hex.*
from std import sync.*
from std import collection.*

main() {
    let quotedPrintableDecoderTest = QuotedPrintableDecoderTest()

    quotedPrintableDecoderTest.test1()
    quotedPrintableDecoderTest.test2()
    quotedPrintableDecoderTest.test3()
    quotedPrintableDecoderTest.test4()
    quotedPrintableDecoderTest.test5()
    quotedPrintableDecoderTest.test6()
    quotedPrintableDecoderTest.test7()
    quotedPrintableDecoderTest.test8()
    quotedPrintableDecoderTest.test9()
    quotedPrintableDecoderTest.test10()
    quotedPrintableDecoderTest.test11()

    return 0
}

@Test
public class QuotedPrintableDecoderTest {
    @TestCase
    public func test1(): Unit {
        let encoded: String = ""
        let clearText: String = ""

        let encodedData: Array<UInt8> = encoded.toUtf8Array()

        let actual: String = QuotedPrintableDecoder.decode(encodedData)
        @Assert(clearText, actual)

        println("Pass1")
    }

    @TestCase
    public func test2(): Unit {
        let encoded: String = "The quick brown fox jumps over the lazy dog."
        let clearText: String = "The quick brown fox jumps over the lazy dog."

        let encodedData: Array<UInt8> = encoded.toUtf8Array()

        let actual: String = QuotedPrintableDecoder.decode(encodedData)
        @Assert(clearText, actual)

        println("Pass2")
    }

    @TestCase
    public func test3(): Unit {
        let clearText: String = "= Hello there =\r\n"
        let encoded: String = "=3D Hello there =3D=0D=0A"

        let encodedData: Array<UInt8> = encoded.toUtf8Array()

        let actual: String = QuotedPrintableDecoder.decode(encodedData)
        @Assert(clearText, actual)
        println("Pass3")
    }

    @TestCase
    public func test4(): Unit {
        let clearText: String = "truncated escape sequence"
        let encoded: String = "YWJjMTIzXy0uKn4hQCMkJV4mKCkre31cIlxcOzpgLC9bXQ=="

        let encodedData: Array<UInt8> = encoded.toUtf8Array()

        try {
            let actual: String = QuotedPrintableDecoder.decode(encodedData)
        } catch (e: QDecoderException) {
            if (e.toString().contains("Invalid quoted printable encoding; truncated escape sequence")) {
                println("Pass4")
            }
        }
    }

    @TestCase
    public func test5(): Unit {
        let clearText: String = "=\r\n"
        let encoded: String = "=3D=0D=0A"

        let encodedData: Array<UInt8> = encoded.toUtf8Array()

        let actual: String = QuotedPrintableDecoder.decode(encodedData)
        @Assert(clearText, actual)
        println("Pass5")
    }

    @TestCase
    public func test6(): Unit {
        let clearText: String = "=\r\n"
        let encoded: String = "=3d=0d=0a"

        let encodedData: Array<UInt8> = encoded.toUtf8Array()

        let actual: String = QuotedPrintableDecoder.decode(encodedData)
        @Assert(clearText, actual)
        println("Pass6")
    }

    @TestCase
    public func test7(): Unit {
        let clearText: String = "=\r\n"
        let encoded: String = "=3D=XD=XA"

        let encodedData: Array<UInt8> = encoded.toUtf8Array()

        try {
            let actual: String = QuotedPrintableDecoder.decode(encodedData)
        } catch (e: QDecoderException) {
            if (e.toString().contains("HexToBinary fail")) {
                println("Pass7")
            }
        }
    }

    @TestCase
    public func test8(): Unit {
        let clearText: String =
            "If you believe that truth=beauty, then surely mathematics is the most beautiful branch of philosophy."
        let encoded: String =
            "If you believe that truth=3Dbeauty, then surely=20=\r\nmathematics is the most beautiful branch of philosophy."

        let encodedData: Array<UInt8> = encoded.toUtf8Array()

        let actual: String = QuotedPrintableDecoder.decode(encodedData)
        @Assert(clearText, actual)
        println("Pass8")
    }

    @TestCase
    public func test9(): Unit {
        let clearText: String = "CR must be followed by LF"
        let encoded: String = "=\r\r"
        let encodedData: Array<UInt8> = encoded.toUtf8Array()

        try {
            let actual: String = QuotedPrintableDecoder.decode(encodedData)
        } catch (e: QDecoderException) {
            if (e.toString().contains("Invalid quoted printable encoding; CR must be followed by LF")) {
                println("Pass9")
            }
        }
    }

    @TestCase
    public func test10(): Unit {
        let clearText: String = "CR must be followed by LF"
        let encoded: String = "=\rn"
        let encodedData: Array<UInt8> = encoded.toUtf8Array()

        try {
            let actual: String = QuotedPrintableDecoder.decode(encodedData)
        } catch (e: QDecoderException) {
            if (e.toString().contains("Invalid quoted printable encoding; CR must be followed by LF")) {
                println("Pass10")
            }
        }
    }

    @TestCase
    public func test11(): Unit {
        let clearText: String = "truncated"
        let encoded: String = "=1"
        let encodedData: Array<UInt8> = encoded.toUtf8Array()

        try {
            let actual: String = QuotedPrintableDecoder.decode(encodedData)
        } catch (e: QDecoderException) {
            if (e.toString().contains("Invalid quoted printable encoding; truncated escape sequence")) {
                println("Pass11")
            }
        }
    }
}

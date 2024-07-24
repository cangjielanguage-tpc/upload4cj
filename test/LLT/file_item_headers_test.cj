// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import upload4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import net.http.*
import std.io.*

main() {

    let fileItemHeadersTest = FileItemHeadersTest()
    fileItemHeadersTest.test1()
    fileItemHeadersTest.test2()
    fileItemHeadersTest.test3()

    return 0

}
@Test
public class FileItemHeadersTest {

    @TestCase
    public func test1(): Unit {
        var aMutableFileItemHeaders: FileItemHeadersImpl = FileItemHeadersImpl()
        aMutableFileItemHeaders.addHeader("Content-Disposition",
            "form-data; name=\"FileItem\"; filename=\"file1.txt\"")


        aMutableFileItemHeaders.addHeader("Content-Type", "text/plain")

        aMutableFileItemHeaders.addHeader("TestHeader", "headerValue1")
        aMutableFileItemHeaders.addHeader("TestHeader", "headerValue2")
        aMutableFileItemHeaders.addHeader("TestHeader", "headerValue3")
        aMutableFileItemHeaders.addHeader("testheader", "headerValue4")

        var headerNameEnumeration: Iterator<String> = aMutableFileItemHeaders.getHeaderNames()
        let a:String = headerNameEnumeration.next().getOrThrow()
        let b:String = headerNameEnumeration.next().getOrThrow()
        let c:String = headerNameEnumeration.next().getOrThrow()

        @Assert(a, "content-disposition")
        @Assert(b, "content-type")
        @Assert(c, "testheader")
        @Assert(headerNameEnumeration.next(), Option<String>.None)

        println("Pass1")
    }

    @TestCase
    public func test2(): Unit {
        var aMutableFileItemHeaders: FileItemHeadersImpl = FileItemHeadersImpl()
        aMutableFileItemHeaders.addHeader("Content-Disposition",
            "form-data; name=\"FileItem\"; filename=\"file1.txt\"")

        aMutableFileItemHeaders.addHeader("Content-Type", "text/plain")

        aMutableFileItemHeaders.addHeader("TestHeader", "headerValue1")
        aMutableFileItemHeaders.addHeader("TestHeader", "headerValue2")
        aMutableFileItemHeaders.addHeader("TestHeader", "headerValue3")
        aMutableFileItemHeaders.addHeader("testheader", "headerValue4")

        let a: Option<String> = aMutableFileItemHeaders.getHeader("Content-Disposition")
        let b: Option<String> = aMutableFileItemHeaders.getHeader("Content-Type")
        let c: Option<String> = aMutableFileItemHeaders.getHeader("content-Type")
        let d: Option<String> = aMutableFileItemHeaders.getHeader("TestHeader")
        let e: Option<String> = aMutableFileItemHeaders.getHeader("DummyHeader")

        @Assert(a.getOrThrow(), "form-data; name=\"FileItem\"; filename=\"file1.txt\"")
        @Assert(b, "text/plain")
        @Assert(c, "text/plain")
        @Assert(d, "headerValue1")
        @Assert(e, Option<String>.None)

        println("Pass2")
    }

    @TestCase
    public func test3(): Unit {
        var aMutableFileItemHeaders: FileItemHeadersImpl = FileItemHeadersImpl()
        aMutableFileItemHeaders.addHeader("Content-Disposition",
            "form-data; name=\"FileItem\"; filename=\"file1.txt\"")

        aMutableFileItemHeaders.addHeader("Content-Type", "text/plain")

        aMutableFileItemHeaders.addHeader("TestHeader", "headerValue1")
        aMutableFileItemHeaders.addHeader("TestHeader", "headerValue2")
        aMutableFileItemHeaders.addHeader("TestHeader", "headerValue3")
        aMutableFileItemHeaders.addHeader("testheader", "headerValue4")

        let a: Iterator<String> = aMutableFileItemHeaders.getHeaders("Content-Type")
        let b: Iterator<String> = aMutableFileItemHeaders.getHeaders("content-Type")
        let c: Iterator<String> = aMutableFileItemHeaders.getHeaders("TestHeader")
        let d: Iterator<String> = aMutableFileItemHeaders.getHeaders("DummyHeader")

        @Assert(a.next().getOrThrow(), "text/plain")
        @Assert(a.next(), Option<String>.None)
        @Assert(b.next().getOrThrow(), "text/plain")
        @Assert(b.next(), Option<String>.None)
        @Assert(c.next().getOrThrow(), "headerValue1")
        @Assert(c.next().getOrThrow(), "headerValue2")
        @Assert(c.next().getOrThrow(), "headerValue3")
        @Assert(c.next().getOrThrow(), "headerValue4")
        @Assert(c.next(), Option<String>.None)
        @Assert(d.next(), Option<String>.None)
        println("Pass3")
    }
}
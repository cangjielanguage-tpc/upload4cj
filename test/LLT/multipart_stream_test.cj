// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
from upload4cj import upload4cj.*
from std import unittest.*
from std import unittest.testmacro.*
from net import http.*
from std import io.*

main() {
    let multipartStreamTest = MultipartStreamTest()
    multipartStreamTest.test1()
    multipartStreamTest.test2()
    multipartStreamTest.test3()

    return 0
}

@Test
public class MultipartStreamTest {
    @TestCase
    public func test1(): Unit {
        var threw: Bool = false
        try {
            var input = ByteArrayStream()
            input.write("foobar".toArray())

            let boundary: Option<Array<UInt8>> = "myboundary".toArray()

            let iBufSize = 1

            let notifier = Option<ProgressNotifier>.None

            MultipartStream(input, boundary, iBufSize, notifier)
        } catch (e: IllegalArgumentException) {
            if (e.message == "The buffer size specified for the MultipartStream is too small") {
                threw = true
            }
        }
        @Assert(threw, true)

        println("Pass1")
    }

    @TestCase
    public func test2(): Unit {
        var threw: Bool = true
        try {
            var input = ByteArrayStream()
            input.write("foobar".toArray())

            let boundary: Option<Array<UInt8>> = "myboundary".toArray()

            let notifier = Option<ProgressNotifier>.None

            MultipartStream(input, boundary, notifier)
        } catch (e: Exception) {
            threw = false
        }
        @Assert(threw, true)

        println("Pass2")
    }

    @TestCase
    public func test3(): Unit {
        var threw: Bool = false

        try {
            var input = ByteArrayStream()
            input.write("foobar".toArray())

            let boundary = Option<Array<UInt8>>.None

            let iBufSize = 4096

            let notifier = Option<ProgressNotifier>.None

            MultipartStream(input, boundary, iBufSize, notifier)
        } catch (e: IllegalArgumentException) {
            if (e.message == "boundary may not be null") {
                threw = true
            }
        }

        @Assert(threw, true)

        println("Pass3")
    }
}

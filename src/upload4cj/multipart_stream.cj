/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

from std import math.*

public class MultipartStream {

    let CR: UInt8 = 0x0D

    let LF: UInt8 = 0x0A

    let DASH: UInt8 = 0x2D

    let HEADER_PART_SIZE_MAX: Int64 = 10240

    private static let DEFAULT_BUFSIZE: Int64 = 4096

    protected let HEADER_SEPARATOR: Array<UInt8> = [CR, LF, CR, LF]

    protected let FIELD_SEPARATOR: Array<UInt8> = [CR, LF]

    protected let STREAM_TERMINATOR: Array<UInt8> = [DASH, DASH]

    protected let BOUNDARY_PREFIX: Array<UInt8> = [CR, LF, DASH, DASH]

    let input: InputStream

    private var boundaryLength: Int64

    let keepRegion: Int64

    private let boundary: Array<UInt8>

    private let boundaryTable: Array<Int64>

    var bufSize: Int64

    let buffer: Array<UInt8>

    var head: Int64 = 0

    var tail: Int64 = 0

    private var headerEncoding = Option<String>.None

    let notifier: Option<ProgressNotifier>

    public init(input: InputStream, boundary: Option<Array<UInt8>>, bufSize: Int64, pNotifier: Option<ProgressNotifier>) {

        if (boundary == Option<Array<UInt8>>.None) {
            throw IllegalArgumentException("boundary may not be null")
        }

        this.boundaryLength = boundary.getOrThrow().size + BOUNDARY_PREFIX.size

        if (bufSize < this.boundaryLength + 1) {
            throw IllegalArgumentException(
                    "The buffer size specified for the MultipartStream is too small")
        }
        this.input = input
        this.bufSize = max(bufSize, boundaryLength * 2)

        this.buffer = Array<UInt8>(this.bufSize, item: 0)
        this.notifier = pNotifier

        this.boundary = Array<UInt8>(this.boundaryLength, item: 0)
        this.boundaryTable = Array<Int64>(this.boundaryLength + 1, item: 0)
        this.keepRegion = this.boundary.size

        BOUNDARY_PREFIX.copyTo(this.boundary, 0, 0, BOUNDARY_PREFIX.size)

        boundary.getOrThrow().copyTo(this.boundary, 0, BOUNDARY_PREFIX.size, boundary.getOrThrow().size)
        computeBoundaryTable()
        head = 0
        tail = 0
    }

    public init(input: InputStream, boundary: Option<Array<UInt8>>, pNotifier: Option<ProgressNotifier>) {
        this(input, boundary, DEFAULT_BUFSIZE, pNotifier)
    }

    public func getHeaderEncoding(): Option<String> {
        return headerEncoding
    }

    public func setHeaderEncoding(encoding: Option<String>) {
        headerEncoding = encoding
    }

    public func readByte(): UInt8 {
        // Buffer depleted ?
        if (head == tail) {
            head = 0
            // Refill.
            var bufferTemp = buffer[head..head + bufSize]
            tail = input.read(bufferTemp)
            bufferTemp.copyTo(buffer, 0, head, bufSize)

            if (tail <= 0) {
                // No more data available.
                throw FileUploadException("No more data is available")
            }

            if(let Some(i) = notifier){
                i.noteBytesRead(tail)
            }
        }
        var retCode = buffer[head]
        head++
        return retCode
    }

    public func readBoundary(): Bool {
        var marker: Array<UInt8> = Array<UInt8>(2, item: 0)
        var nextChunk: Bool = false

        head = head + boundaryLength
        try {
            marker[0] = readByte()
            if (marker[0] == LF) {
                // Work around IE5 Mac bug with input type=image.
                // Because the boundary delimiter, not including the trailing
                // CRLF, must not appear within any file (RFC 2046, section
                // 5.1.1), we know the missing CR is due to a buggy browser
                // rather than a file containing something similar to a
                // boundary.
                return true
            }
            marker[1] = readByte()
            if (arrayequals(marker, STREAM_TERMINATOR, 2)) {
                nextChunk = false
            } else if (arrayequals(marker, FIELD_SEPARATOR, 2)) {
                nextChunk = true
            } else {
                throw MalformedStreamException("Unexpected characters follow a boundary")
            }
        } catch (e: FileUploadIOException) {
            // wraps a SizeException, re-throw as it will be unwrapped later
            throw e
        } catch (e: IOException) {
            throw MalformedStreamException("Stream ended unexpectedly")
        }
        return nextChunk
    }

    public func setBoundary(boundary: Array<UInt8>) {
        if (boundary.size != boundaryLength - BOUNDARY_PREFIX.size) {
            throw IllegalBoundaryException(
            "The length of a boundary token cannot be changed");
        }

        boundary.copyTo(this.boundary, 0, BOUNDARY_PREFIX.size, boundary.size)
        computeBoundaryTable()
    }

    private func computeBoundaryTable() {
        var position: Int64 = 2
        var candidate: Int64 = 0

        boundaryTable[0] = -1
        boundaryTable[1] = 0

        while (position <= boundaryLength) {
            if (boundary[position - 1] == boundary[candidate]) {
                boundaryTable[position] = candidate + 1
                candidate++
                position++
            } else if (candidate > 0) {
                candidate = boundaryTable[candidate]
            } else {
                boundaryTable[position] = 0
                position++
            }
        }
    }

    public func readHeaders(): String {
        var i: Int64 = 0
        var b: UInt8
        // to support multi-byte characters
        var baos = ByteArrayStream()
        var size: Int64 = 0
        let arrayUint = ArrayList<UInt8>()
        while (i < HEADER_SEPARATOR.size) {
            try {
                b = readByte()
            } catch (e: FileUploadIOException) {
                // wraps a SizeException, re-throw as it will be unwrapped later
                throw e
            } catch (e: IOException) {
                throw MalformedStreamException("Stream ended unexpectedly")
            }
            size ++
            if (size > HEADER_PART_SIZE_MAX) {
                throw MalformedStreamException("Header section has more than %s bytes (maybe it is not properly terminated)")
            }
            if (b == HEADER_SEPARATOR[i]) {
                i++
            } else {
                i = 0
            }
            arrayUint.append(b)
        }
        baos.write(arrayUint.toArray())

        var headers: String = ""

        let isHeaderEncoding = match (headerEncoding) {
            case Some(v) => true
            case None => false
        }

        if (isHeaderEncoding) {
            try {
                // bytes -> String
                 headers = String.fromUtf8(baos.readToEnd())
            } catch (e: IOException) {
                // Fall back to platform default if specified encoding is not
                // supported.
                 headers = String.fromUtf8(baos.readToEnd())
            }
        } else {
                 headers = String.fromUtf8(baos.readToEnd())
        }
        return headers
    }

    func newInputStream():ItemInputStream{
        return ItemInputStream(this)
    }

    public func discardBodyData():Int64{
        return readBodyData(Option<OutputStream>.None)
    }

    public func skipPreamble():Bool{
        boundary.copyTo(boundary, 2, 0, boundary.size - 2)
        boundaryLength = boundary.size - 2
        computeBoundaryTable()
        try{
            discardBodyData()
            return readBoundary()
        }catch(e:MalformedStreamException){
            return false
        }finally{
            boundary.copyTo(boundary,0,2,boundary.size - 2)
            boundaryLength = boundary.size
            boundary[0] = CR
            boundary[1] = LF
            computeBoundaryTable()
        }
    }

    public static func arrayequals(a: Array<UInt8>, b: Array<UInt8>, count: Int64): Bool {
        for (i in 0..count) {
            if (a[i] != b[i]) {
                return false
            }
        }
        return true
    }

    protected func findByte(value: UInt8, pos: Int64): Int64 {
        for (i in pos..tail) {
            if (buffer[i] == value) {
                return i
            }
        }

        return -1
    }

    protected func findSeparator():Int64{
        var bufferPos:Int64 = this.head
        var tablePos:Int64 = 0
        while(bufferPos < this.tail){
            while(tablePos>=0 && buffer[bufferPos] != boundary[tablePos]) {
                tablePos = boundaryTable[tablePos]
            }
            bufferPos++
            tablePos++
            if (tablePos == boundaryLength) {
                return bufferPos - boundaryLength
            }
        }
        return -1
    }

    public func readBodyData(output:Option<OutputStream>):Int64{
        return Streams.copy(newInputStream(), output, false)
    }

}

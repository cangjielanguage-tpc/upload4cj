/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package upload4cj


/**
 * MultipartStream
 */
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

    /**
     * init
     *
     * @param input - InputStream The InputStream
     * @param boundary - Option<Array<UInt8>> The data Array
     * @param bufSize - Int64 The buffer size
     * @param pNotifier - Option<ProgressNotifier> The ProgressNotifier
     */
    public init(input: InputStream, boundary: Option<Array<UInt8>>, bufSize: Int64, pNotifier: Option<ProgressNotifier>) {
        if (boundary == Option<Array<UInt8>>.None) {
            throw IllegalArgumentException("boundary may not be null")
        }

        this.boundaryLength = boundary.getOrThrow().size + BOUNDARY_PREFIX.size

        if (bufSize < this.boundaryLength + 1) {
            throw IllegalArgumentException("The buffer size specified for the MultipartStream is too small")
        }
        this.input = input
        this.bufSize = max(bufSize, boundaryLength * 2)

        this.buffer = Array<UInt8>(this.bufSize, repeat: 0)
        this.notifier = pNotifier

        this.boundary = Array<UInt8>(this.boundaryLength, repeat: 0)
        this.boundaryTable = Array<Int64>(this.boundaryLength + 1, repeat: 0)
        this.keepRegion = this.boundary.size

        BOUNDARY_PREFIX.copyTo(this.boundary, 0, 0, BOUNDARY_PREFIX.size)

        boundary.getOrThrow().copyTo(this.boundary, 0, BOUNDARY_PREFIX.size, boundary.getOrThrow().size)
        computeBoundaryTable()
        head = 0
        tail = 0
    }

    /**
     * init
     *
     * @param input - InputStream The InputStream
     * @param boundary - Option<Array<UInt8>> The data Array
     * @param pNotifier - Option<ProgressNotifier> The ProgressNotifier
     */
    public init(input: InputStream, boundary: Option<Array<UInt8>>, pNotifier: Option<ProgressNotifier>) {
        this(input, boundary, DEFAULT_BUFSIZE, pNotifier)
    }

    /**
     * get the Header Encoding
     *
     * @return Option<String> - the Header Encoding
     */
    public func getHeaderEncoding(): Option<String> {
        return headerEncoding
    }

    /**
     * set the Header Encoding
     *
     * @param encoding - Option<String> the Header Encoding
     */
    public func setHeaderEncoding(encoding: Option<String>) {
        headerEncoding = encoding
    }

    /**
     * read the byte data
     *
     * @return UInt8 - The byte data
     */
    public func readByte(): UInt8 {
        // Buffer depleted ?
        if (head == tail) {
            head = 0

            // Refill.
             //var bufferTemp = buffer[head..head + bufSize]
             //tail = input.read(bufferTemp)
             //bufferTemp.copyTo(buffer, 0, head, bufSize)
            tail = input.read(buffer[head..head + bufSize])

            if (tail <= 0) {
                // No more data available.
                throw ReadWriteException("No more data is available")
            }

            if (let Some(i) <- notifier) {
                i.noteBytesRead(tail)
            }
        }
        var retCode = buffer[head]
        head++
        return retCode
    }

    /**
     * read the boundary
     *
     * @return Bool - ok or fault
     */
    public func readBoundary(): Bool {
        //var BoundaryMarker: Array<UInt8> = Array<UInt8>(2, repeat: 0)
        var BoundaryMarker1:UInt8 = 0
        var BoundaryMarker2:UInt8 = 0
        var nextChunk: Bool = false

        head = head + boundaryLength
        try {
            BoundaryMarker1 = readByte()
            if (BoundaryMarker1 == LF) {
                return true
            }
            BoundaryMarker2 = readByte()
            if (arrayequals(BoundaryMarker1,BoundaryMarker2, STREAM_TERMINATOR)) {
                nextChunk = false
            } else if (arrayequals(BoundaryMarker1,BoundaryMarker2, FIELD_SEPARATOR)) {
                nextChunk = true
            } else {
                throw MalformedStreamException("Unexpected characters follow a boundary")
            }
        } catch (e: FileUploadException) {
            // wraps a SizeException, re-throw as it will be unwrapped later
            throw e
        } catch (e: ReadWriteException) {
            throw MalformedStreamException("Stream ended unexpectedly")
        }
        return nextChunk
    }

    /**
     * set the boundary
     *
     * @param boundary - Array<UInt8> the boundary(byte array)
     */
    public func setBoundary(boundary: Array<UInt8>) {
        if (boundary.size != boundaryLength - BOUNDARY_PREFIX.size) {
            throw IllegalBoundaryException("The length of a boundary token cannot be changed");
        }

        boundary.copyTo(this.boundary, 0, BOUNDARY_PREFIX.size, boundary.size)
        computeBoundaryTable()
    }

    private func computeBoundaryTable() {
        var cjPosition: Int64 = 2
        var candidate: Int64 = 0

        boundaryTable[0] = -1
        boundaryTable[1] = 0

        while (cjPosition <= boundaryLength) {
            if (boundary[cjPosition - 1] == boundary[candidate]) {
                boundaryTable[cjPosition] = candidate + 1
                candidate++
                cjPosition++
            } else if (candidate > 0) {
                candidate = boundaryTable[candidate]
            } else {
                boundaryTable[cjPosition] = 0
                cjPosition++
            }
        }
    }

    /**
     * read Headers
     *
     * @return String - The headers
     */
    public func readHeaders(): String {
        var i: Int64 = 0
        var b: UInt8

        // to support multi-byte characters
        var baos = ByteBuffer()
        var size: Int64 = 0
        let arrayUint = ArrayList<UInt8>()
        while (i < HEADER_SEPARATOR.size) {
            try {
                b = readByte()
            } catch (e: FileUploadException) {
                throw FileUploadException("Headers Get Fail")
            } catch (e: ReadWriteException) {
                throw MalformedStreamException("Stream ended unexpectedly")
            }
            size++
            if (size > HEADER_PART_SIZE_MAX) {
                throw MalformedStreamException(
                    "Header section has more than %s bytes (maybe it is not properly terminated)")
            }
            if (b == HEADER_SEPARATOR[i]) {
                i++
            } else {
                i = 0
            }
            arrayUint.add(b)
        }
        baos.write(arrayUint.toArray())


        let isHeaderEncoding = match (headerEncoding) {
            case Some(_) => true
            case None => false
        }

        if (isHeaderEncoding) {
            try {
                // bytes -> String
                  unsafe{
                    return String.fromUtf8Unchecked(readToEnd(baos))
                  }
            } catch (e: ReadWriteException) {
                // Fall back to platform default if specified encoding is not
                // supported.
                unsafe{
                    return String.fromUtf8Unchecked(readToEnd(baos))
                  }            }
        } else {
                unsafe{
                    return String.fromUtf8Unchecked(readToEnd(baos))
                  }
        }
    }

    func newInputStream(): ItemInputStream {
        return ItemInputStream(this)
    }

    /**
     * discard BodyData
     *
     * @return Int64 - the byte size
     */
    public func discardBodyData(): Int64 {
        return readBodyData(Option<OutputStream>.None)
    }

    /**
     * skip Preamble
     *
     * @return Bool - true or fault
     */
    public func skipPreamble(): Bool {
        boundary.copyTo(boundary, 2, 0, boundary.size - 2)
        boundaryLength = boundary.size - 2
        computeBoundaryTable()
        try {
            discardBodyData()
            return readBoundary()
        } catch (e: MalformedStreamException) {
            return false
        } finally {
            boundary.copyTo(boundary, 0, 2, boundary.size - 2)
            boundaryLength = boundary.size
            boundary[0] = CR
            boundary[1] = LF
            computeBoundaryTable()
        }
    }

    /**
     * array equals tool
     *
     * @param a - Array<UInt8> UInt8 Array a
     * @param b - Array<UInt8> UInt8 Array b
     * @return Bool - true(equal) false(unequal)
     */
    public static func arrayequals(a: Array<UInt8>, b: Array<UInt8>, count: Int64): Bool {
        for (i in 0..count) {
            if (a[i] != b[i]) {
                return false
            }
        }
        return true
    }

    protected static func arrayequals(a1:UInt8,a2:UInt8, b: Array<UInt8>): Bool {
        return (a1 == b[0] && a2 == b[1])
    }

    protected func findByte(value: UInt8, pos: Int64): Int64 {
        for (i in pos..tail) {
            if (buffer[i] == value) {
                return i
            }
        }

        return -1
    }

    protected func findSeparator(): Int64 {
        var bufferPos: Int64 = this.head
        var tableP: Int64 = 0
        while (bufferPos < this.tail) {
            while (tableP >= 0 && buffer[bufferPos] != boundary[tableP]) {
                tableP = boundaryTable[tableP]
            }
            bufferPos++
            tableP++
            if (tableP == boundaryLength) {
                let separator: Int64 = bufferPos - boundaryLength
                return separator
            }
        }
        return -1
    }

    /**
     * read BodyData
     *
     * @param outputStream - Option<OutputStream> the body OutputStream
     * @return Int64 - read the size
     */
    public func readBodyData(outputStream: Option<OutputStream>): Int64 {
        return Streams.copy(newInputStream(), outputStream, false)
    }
}

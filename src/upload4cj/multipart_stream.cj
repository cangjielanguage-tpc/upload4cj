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

    private let input: InputStream

    private var boundaryLength: Int64

    private let keepRegion: Int64
 
    private let boundary: Array<UInt8>

    private let boundaryTable: Array<Int64>

    private let bufSize: Int64

    private let buffer: Array<UInt8>

    private var head: Int64 = 0

    private var tail: Int64 = 0

    private var headerEncoding = Option<String>.None

    private let notifier: Option<ProgressNotifier>

    public init(input: InputStream, boundary: Option<Array<UInt8>>, bufSize: Int64, pNotifier: Option<ProgressNotifier>) {

        let isBoundary = match (boundary) {
            case Some(v) => true
            case None => false
        }

        if (!isBoundary) {
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
        boundary.getOrThrow().copyTo(this.boundary, 0, 0, boundary.getOrThrow().size)

        head = 0
        tail = 0

    }

    public init(input: InputStream, boundary: Option<Array<UInt8>>, pNotifier: ProgressNotifier) {
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
            tail = input.read(buffer)
            if (tail == -1) {
                // No more data available.
                throw IOException("No more data is available")
            }

            let isNotifier = match (notifier) {
                case Some(v) => true
                case None => false
            } 

            if (!isNotifier) {
                notifier.getOrThrow().noteBytesRead(tail)
            }
        }
        head++
        return buffer[head-1]
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
                throw IOException("Unexpected characters follow a boundary")
            }
        } catch (e: FileUploadIOException) {
            // wraps a SizeException, re-throw as it will be unwrapped later
            throw e
        } catch (e: IOException) {
            throw IOException("Stream ended unexpectedly")
        }
        return nextChunk
    }

    public func setBoundary(boundary: Array<UInt8>) {
        if (boundary.size != boundaryLength - BOUNDARY_PREFIX.size) {
            throw IllegalBoundaryException(
            "The length of a boundary token cannot be changed");
        }

        boundary.copyTo(this.boundary, 0, 0, boundary.size)
        computeBoundaryTable();
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
        while (i < HEADER_SEPARATOR.size) {
            try {
                b = readByte()
            } catch (e: FileUploadIOException) {
                // wraps a SizeException, re-throw as it will be unwrapped later
                throw e
            } catch (e: IOException) {
                throw IOException("Stream ended unexpectedly")
            }
            size ++
            if (size > HEADER_PART_SIZE_MAX) {
                throw IOException("Header section has more than %s bytes (maybe it is not properly terminated)")
            }
            if (b == HEADER_SEPARATOR[i]) {
                i++
            } else {
                i = 0
            }
            var array: Array<UInt8> = Array<UInt8>(1, item: b)
            baos.write(b)
            baos.write(array)
        }

        var headers: String

        let isHeaderEncoding = match (headerEncoding) {
            case Some(v) => true
            case None => false
        }

        if (isHeaderEncoding) {
            try {
                // bytes -> String
                var headersArray = baos.bytes()
                headers = ""
            } catch (e: IOException) {
                // Fall back to platform default if specified encoding is not
                // supported.
                var headersArray = baos.bytes()
                headers = ""
            }
        } else {
            var headersArray = baos.bytes()
            headers = ""
        }

        return headers
    }

    public static func arrayequals(a: Array<UInt8>, b: Array<UInt8>, count: Int64): Bool {
        for (i in 0..count) {
            if (a[i] != b[i]) {
                return false
            }
        }
        return true
    }


}

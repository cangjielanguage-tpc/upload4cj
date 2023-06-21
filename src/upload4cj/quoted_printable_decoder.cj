/*
 * Copyright (c) Cangjie Library Team 2023-2023. All rights resvered.
 */

package upload4cj

from encoding import hex.*

public class QuotedPrintableDecoder {
    private static let UPPER_NIBBLE_SHIFT: Int64 = 4

    public static func decode(data: Array<UInt8>): String {
        var off: Int64 = 0
        var length: Int64 = data.size
        var endOffset: Int64 = off + length

        var out: ByteArrayStream = ByteArrayStream()

        while (off < endOffset) {
            var ch: UInt8 = data[off]
            off++
            if (Char(ch) == '_') {
                out.write(String(' ').toUtf8Array())
            } else if (Char(ch) == '=') {
                if (off + 1 >= endOffset) {
                    throw QDecoderException("Invalid quoted printable encoding; truncated escape sequence")
                }
                let b1: UInt8 = data[off]
                off++
                let b2: UInt8 = data[off]
                off++

                if (Char(b1) == '\r') {
                    if (Char(b2) != '\n') {
                        throw QDecoderException("Invalid quoted printable encoding; CR must be followed by LF")
                    }
                } else {
                    let b: UInt8 = hexToBinary(b1, b2)
                    out.write(String(Char(b)).toUtf8Array())
                }
            } else {
                out.write(ch)
            }
        }
        var str = String.fromUtf8(out.readToEnd())
        return str
    }

    private static func hexToBinary(b1: UInt8, b2: UInt8): UInt8 {
        var arr = Array<UInt8>([b1, b2])
        var sString: String = String.fromUtf8(arr)
        var opArr: Option<Array<UInt8>> = fromHexString(sString)
        var arr2: Array<UInt8> = match (opArr) {
            case Some(s) => s
            case None => Array<UInt8>()
        }
        if (arr2.size != 1) {
            throw QDecoderException("HexToBinary fail")
        }
        return arr2[0]
    }
}

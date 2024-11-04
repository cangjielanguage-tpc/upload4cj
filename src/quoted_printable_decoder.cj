/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package upload4cj


/**
 * QuotedPrintableDecoder
 */
class QuotedPrintableDecoder {

    public static func decode(data: Array<UInt8>): String {
        var off: Int64 = 0
        var length: Int64 = data.size
        var endOffset: Int64 = off + length

        var out: ByteBuffer = ByteBuffer()

        while (off < endOffset) {
            var ch: UInt8 = data[off]
            off++
            if (Rune(ch) == r'_') {
                out.write(String(r' ').toUtf8Array())
            } else if (Rune(ch) == r'=') {
                if (off + 1 >= endOffset) {
                    throw QDecoderException("Invalid quoted printable encoding; truncated escape sequence")
                }
                let b1: UInt8 = data[off]
                off++
                let b2: UInt8 = data[off]
                off++

                if (Rune(b1) == r'\r') {
                    if (Rune(b2) != r'\n') {
                        throw QDecoderException("Invalid quoted printable encoding; CR must be followed by LF")
                    }
                } else {
                    let b: UInt8 = hexToBinary(b1, b2)
                    out.write(b)
                }
            } else {
                out.write(ch)
            }
        }
        if (out.length == 0) {
            return ""
        }
        var str = ""
        unsafe{
            str = String.fromUtf8Unchecked(readToEnd(out))
        }
        return str
    }

    private static func hexToBinary(b1: UInt8, b2: UInt8): UInt8 {
        var arr = [b1, b2]
        var sString = ""
        unsafe{
            sString = String.fromUtf8Unchecked(arr)
        }
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

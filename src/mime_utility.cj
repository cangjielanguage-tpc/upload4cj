/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package upload4cj

/**
 * MimeUtility
 */
public class MimeUtility {
    private static let BASE64_ENCODING_MARKER: String = "B"

    private static let QUOTEDPRINTABLE_ENCODING_MARKER: String = "Q"

    private static let ENCODED_TOKEN_MARKER: String = "=?"

    private static let ENCODED_TOKEN_FINISHER: String = "?="

    private static let LINEAR_WHITESPACE: String = " \t\r\n"

    /**
     * decode the Text
     *
     * @param text - String the Text
     * @return Option<String> - the Text decoded
     */
    public static func decodeText(text: String): Option<String> {

        if (text.indexOf(ENCODED_TOKEN_MARKER).isNone()) {
            return text
        }

        let textRuneArray = text.toRuneArray()
        
        var offset: Int64 = 0
        var endOffset: Int64 = textRuneArray.size
        var startWhiteSpace: Int64 = -1
        var endWhiteSpace: Int64 = -1
        var decodedText: StringBuilder = StringBuilder()
        var previousTokenEncoded: Bool = false
        while (offset < endOffset) {
            var ch = textRuneArray[offset]
            if (LINEAR_WHITESPACE.indexOf(ch).isSome()) {
                startWhiteSpace = offset
                while (offset < endOffset) {
                    ch = textRuneArray[offset]
                    if (LINEAR_WHITESPACE.indexOf(ch).isSome()) { // whitespace found
                        offset++
                    } else {
                        endWhiteSpace = offset
                        break
                    }
                }
            } else {
                var wordStart: Int64 = offset
                while (offset < endOffset) {
                    ch = textRuneArray[offset]
                    if (LINEAR_WHITESPACE.indexOf(ch).isNone()) {
                        offset++
                    } else {
                        break
                    }
                }
                let word: String = String(textRuneArray.slice(wordStart, offset - wordStart))
                if (word.startsWith(ENCODED_TOKEN_MARKER)) {
                    try {
                        let decodedWord: String = decodeWord(word)
                        if (!previousTokenEncoded && startWhiteSpace != -1) {
                            decodedText.append(textRuneArray.slice(startWhiteSpace, endWhiteSpace - startWhiteSpace))
                            startWhiteSpace = -1
                        }
                        previousTokenEncoded = true
                        decodedText.append(decodedWord)
                        continue
                    } catch (e: ParseException) {}
                }
                if (startWhiteSpace != -1) {
                    decodedText.append(textRuneArray.slice(startWhiteSpace, endWhiteSpace - startWhiteSpace))
                    startWhiteSpace = -1
                }
                previousTokenEncoded = false
                decodedText.append(word)
            }
        }
        return decodedText.toString()
    }

    private static func decodeWord(word: String): String {

        if (!word.startsWith(ENCODED_TOKEN_MARKER)) {
            throw ParseException("Invalid RFC 2047 encoded-word: " + word)
        }

        let wordRuneArray = word.toRuneArray()

        if (wordRuneArray.indexOfRune(r'?', 2) == Option<Int64>.None) {
            throw ParseException("Missing charset in RFC 2047 encoded-word: " + word)
        }
        var charsetPos: Int64 = wordRuneArray.indexOfRune(r'?', 2).getOrThrow()

        if (wordRuneArray.indexOfRune(r'?', charsetPos + 1) == Option<Int64>.None) {
            throw ParseException("Missing encoding in RFC 2047 encoded-word: " + word);
        }

        var encodingPos: Int64 = wordRuneArray.indexOfRune(r'?', charsetPos + 1).getOrThrow()

        let encoding: String = String(wordRuneArray.slice(charsetPos + 1, encodingPos - charsetPos - 1))

        var encodedTextPos:Option<Int64> = wordRuneArray.indexOfRuneArray(ENCODED_TOKEN_FINISHER.toRuneArray(), encodingPos + 1)

        if(encodedTextPos == None){
            throw ParseException("Missing encoded text in RFC 2047 encoded-word: " + word)
        }

        let encodedText: String = String(wordRuneArray.slice(encodingPos + 1, encodedTextPos.getOrThrow() - encodingPos - 1))
        if (encodedText.size == 0) {
            return ""
        }

        try {
            var str: String = ""
            if (encoding.equals(BASE64_ENCODING_MARKER)) {
                var encodedData: Array<UInt8> = fromBase64String(encodedText).getOrThrow()
                unsafe {
                    str = String.fromUtf8Unchecked(encodedData)
                }
            } else if (encoding.equals(QUOTEDPRINTABLE_ENCODING_MARKER)) {
                let encodedData: Array<UInt8> = encodedText.toUtf8Array()
                str = QuotedPrintableDecoder.decode(encodedData)
            } else {
                throw UnsupportedEncodingException("Unknown RFC 2047 encoding: " + encoding)
            }
            return str
        } catch (e: Exception) {
            throw UnsupportedEncodingException("Invalid RFC 2047 encoding")
        }
    }
}

/*
 * Copyright (c) Cangjie Library Team 2023-2023. All rights resvered.
 */

package upload4cj

from encoding import base64.*

public class MimeUtility {
    private static let BASE64_ENCODING_MARKER: String = "B"

    private static let QUOTEDPRINTABLE_ENCODING_MARKER: String = "Q"

    private static let ENCODED_TOKEN_MARKER: String = "=?"

    private static let ENCODED_TOKEN_FINISHER: String = "?="

    private static let LINEAR_WHITESPACE: String = " \t\r\n"

    public static func decodeText(text: String): Option<String> {
        if (text.indexOf(ENCODED_TOKEN_MARKER) == Option<Int64>.None) {
            return text
        }
        var offset: Int64 = 0
        var endOffset: Int64 = text.size

        var startWhiteSpace: Int64 = -1
        var endWhiteSpace: Int64 = -1

        var decodedText: StringBuilder = StringBuilder()

        var previousTokenEncoded: Bool = false
        while (offset < endOffset) {
            var ch = text.charAt(offset)

            if (LINEAR_WHITESPACE.indexOf(ch) != Option<Int64>.None) {
                startWhiteSpace = offset
                while (offset < endOffset) {
                    ch = text.charAt(offset)
                    if (LINEAR_WHITESPACE.indexOf(ch) != Option<Int64>.None) { // whitespace found
                        offset++
                    } else {
                        endWhiteSpace = offset
                        break
                    }
                }
            } else {
                var wordStart: Int64 = offset

                while (offset < endOffset) {
                    ch = text.charAt(offset)
                    if (LINEAR_WHITESPACE.indexOf(ch) == Option<Int64>.None) { // not white space
                        offset++
                    } else {
                        break
                    }
                }
                let word: String = text.substring(wordStart, offset - wordStart)
                if (word.startsWith(ENCODED_TOKEN_MARKER)) {
                    try {
                        let decodedWord: String = decodeWord(word)

                        if (!previousTokenEncoded && startWhiteSpace != -1) {
                            decodedText.append(text.substring(startWhiteSpace, endWhiteSpace - startWhiteSpace))
                            startWhiteSpace = -1
                        }

                        previousTokenEncoded = true

                        decodedText.append(decodedWord)
                        continue
                    } catch (e: ParseException) {
                        throw ParseException("Decode This Text Fail")
                    }
                }
                if (startWhiteSpace != -1) {
                    decodedText.append(text.substring(startWhiteSpace, endWhiteSpace - startWhiteSpace))
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

        if (word.indexOf('?', 2) == Option<Int64>.None) {
            throw ParseException("Missing charset in RFC 2047 encoded-word: " + word)
        }
        var charsetPos: Int64 = word.indexOf('?', 2).getOrThrow()

        let charset: String = word.substring(2, charsetPos - 2).toAsciiLower() // diff java, cj -> substring(beginIndex, length)

        if (word.indexOf('?', charsetPos + 1) == Option<Int64>.None) {
            throw ParseException("Missing encoding in RFC 2047 encoded-word: " + word);
        }
        var encodingPos: Int64 = word.indexOf('?', charsetPos + 1).getOrThrow()

        let encoding: String = word.substring(charsetPos + 1, encodingPos - charsetPos - 1)

        if (word.indexOf(ENCODED_TOKEN_FINISHER, encodingPos + 1) == Option<Int64>.None) {
            throw ParseException("Missing encoded text in RFC 2047 encoded-word: " + word)
        }
        var encodedTextPos: Int64 = word.indexOf(ENCODED_TOKEN_FINISHER, encodingPos + 1).getOrThrow()

        let encodedText: String = word.substring(encodingPos + 1, encodedTextPos - encodingPos - 1)
        if (encodedText.size == 0) {
            return ""
        }

        try {
            var encodedData: Array<UInt8> = fromBase64String(encodedText).getOrThrow()
            var str: String = ""
            if (encoding.equals(BASE64_ENCODING_MARKER)) {
                str = String.fromUtf8(encodedData)
            } else {
                throw UnsupportedEncodingException("Unknown RFC 2047 encoding: " + encoding)
            }
            return str
        } catch (e: Exception) {
            throw UnsupportedEncodingException("Invalid RFC 2047 encoding")
        }
    }
}

/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

from std import unicode.*
from std import collection.*

/**
 * ParameterParser
 */
public class ParameterParser {
    private var chars: Array<Char> = []

    private var pos: Int64 = 0

    private var len: Int64 = 0

    private var i1: Int64 = 0

    private var i2: Int64 = 0

    private var lowerCaseNames: Bool = false

    /**
     * init
     */
    public init() {
        super()
    }

    private func hasChar(): Bool {
        return this.pos < this.len
    }

    /**
     * parse the text
     *
     * @param str - Option<String> The str need to parse
     * @param separators - Option<Array<Char>> The separator array
     * @return Map<String, Option<String>> - the result
     */
    public func parse(str: Option<String>, separators: Option<Array<Char>>): Map<String, Option<String>> {
        match (separators) {
            case None => return HashMap<String, Option<String>>()
            case Some(_) =>
                if (separators.getOrThrow().size == 0) {
                    return HashMap<String, Option<String>>()
                }
        }

        var separator: Char = separators.getOrThrow()[0]
        let isStr = match (str) {
            case None => false
            case Some(_) => true
        }

        if (isStr) {
            var idx: Int64 = str.getOrThrow().size
            for (separatorChar in separators.getOrThrow()) {
                var tmp: Option<Int64> = str.getOrThrow().indexOf(separatorChar)
                let isTmp = match (tmp) {
                    case None => false
                    case Some(_) => true
                }
                if (isTmp && tmp.getOrThrow() < idx) {
                    idx = tmp.getOrThrow()
                    separator = separatorChar
                }
            }
        }
        return parse(str, separator)
    }

    /**
     * parse the text
     *
     * @param str - Option<String> The str need to parse
     * @param separator - Char The separator char
     * @return Map<String, Option<String>> - the result
     */
    public func parse(str: Option<String>, separator: Char): Map<String, Option<String>> {
        match (str) {
            case None => return HashMap<String, Option<String>>()
            case Some(_) =>
                let charArray: Option<Array<Char>> = str.getOrThrow().toCharArray()
                return this.parse(charArray, separator)
        }
    }

    /**
     * parse the Char array
     *
     * @param charArray - Option<Array<Char>> The char array need to parse
     * @param separator - Char The separator char
     * @return Map<String, Option<String>> - the result
     */
    public func parse(charArray: Option<Array<Char>>, separator: Char): Map<String, Option<String>> {
        match (charArray) {
            case None => return HashMap<String, Option<String>>()
            case Some(_) => return this.parse(charArray, 0, charArray.getOrThrow().size, separator)
        }
    }

    /**
     * parse the Char array
     *
     * @param charArray - Option<Array<Char>> The char array need to parse
     * @param offset - Int64 The offset
     * @param length - Int64 The length
     * @param separator - Char The separator char
     * @return Map<String, Option<String>> - the result
     */
    public func parse(charArray: Option<Array<Char>>, offset: Int64, length: Int64, separator: Char): Map<String, Option<String>> {
        match (charArray) {
            case None => return HashMap<String, Option<String>>()
            case Some(_) => this.chars = charArray.getOrThrow()
        }
        var params: HashMap<String, Option<String>> = HashMap<String, Option<String>>()

        this.pos = offset
        this.len = length
        var paramName: Option<String>
        var paramValue: Option<String>

        while (hasChar()) {
            paramName = parseToken('=', separator)
            paramValue = Option<String>.None
            if (hasChar() && charArray.getOrThrow()[pos] == '=') {
                pos++
                paramValue = this.parseQuotedToken(separator)

                try {
                    paramValue = MimeUtility.decodeText(paramValue.getOrThrow())
                } catch (e: Exception) {
                    // let's keep the original value in this case
                }
            }

            if (hasChar() && (charArray.getOrThrow()[pos] == separator)) {
                pos++ // skip separator
            }

            let isParamName = match (paramName) {
                case None => false
                case Some(_) => true
            }

            if (isParamName && (paramName.getOrThrow().size > 0)) {
                if (lowerCaseNames) {
                    paramName = paramName.getOrThrow().toAsciiLower()
                }
                params.put(paramName.getOrThrow(), paramValue)
            }
        }
        return params
    }

    private func parseToken(ch1:Char,ch2:Char): Option<String> {
        this.i1 = this.pos
        this.i2 = this.pos
        while (hasChar()) {
            if(this.pos >= this.chars.size){
                throw IndexOutOfBoundsException("offset is bigger than charArray size")
            }
            var ch: Char = this.chars[this.pos]
            if (isOneOf(ch, ch1,ch2)) {
                break
            }
            this.i2++
            this.pos++
        }
        return getToken(false)
    }

    private func getToken(quoted: Bool): Option<String> {
        // Trim leading white spaces
        while ((i1 < i2) && (chars[i1].isAsciiWhiteSpace())) {
            i1++
        }

        // Trim trailing white spaces
        while ((i2 > i1) && (chars[i2 - 1].isAsciiWhiteSpace())) {
            i2--
        }

        // Strip away quotation marks if necessary
        if (quoted && ((i2 - i1) >= 2) && (chars[i1] == '\"') && (chars[i2 - 1] == '\"')) {
            i1++
            i2--
        }
        var result = Option<String>.None
        if (i2 > i1) {
            result = String(chars.slice(i1,i2 - i1))
            //result = String(chars, start: i1, length: i2 - i1)
        }
        return result
    }

    private func isOneOf(ch: Char, ch1: Char,ch2: Char): Bool {
        return (ch == ch1 || ch == ch2)
    }

    private func isOneOf(ch: Char, ch1:Char): Bool {
        return ch == ch1
    }

    /**
     * support turn to lowerCase Names
     *
     * @return Bool - support or not
     */
    public func isLowerCaseNames(): Bool {
        return lowerCaseNames
    }

    /**
     * set turn to lowerCase Names
     *
     * @param b - Bool turn to lowerCase Names or not
     */
    public func setLowerCaseNames(b: Bool) {
        this.lowerCaseNames = b
    }

    private func parseQuotedToken(terminators:Char): Option<String> {
        i1 = pos
        i2 = pos
        var quoted: Bool = false
        var charEscaped: Bool = false

        while (hasChar()) {
            var ch: Char = chars[pos]
            if (!quoted && this.isOneOf(ch, terminators)) {
                break
            }

            if (!charEscaped && ch == '\"') {
                quoted = !quoted
            }

            charEscaped = (!charEscaped && ch == '\\')
            i2++
            pos++
        }

        return this.getToken(true)
    }
}

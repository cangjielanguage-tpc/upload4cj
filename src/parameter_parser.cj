/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package upload4cj

/**
 * ParameterParser
 */
public class ParameterParser {
    private var chars: Array<Rune> = []

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
     * @param separators - Option<Array<Rune>> The separator array
     * @return Map<String, Option<String>> - the result
     */
    public func parse(str: Option<String>, separators: Option<Array<Rune>>): Map<String, Option<String>> {

        if((separators?.size ?? 0) == 0){
            return HashMap<String, Option<String>>()
        }

        var separator: Rune = separators.getOrThrow()[0]
        let isStr = match (str) {
            case None => false
            case Some(_) => true
        }

        if (isStr) {
            var strRuneArr = str.getOrThrow().toRuneArray()
            var idx: Int64 = strRuneArr.size
            for (separatorChar in separators.getOrThrow()) {
                var tmp: Option<Int64> = strRuneArr.indexOfRune(separatorChar,
                    0)
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
    public func parse(str: Option<String>, separator: Rune): Map<String, Option<String>> {
        match (str) {
            case None => return HashMap<String, Option<String>>()
            case Some(v) =>
                let charArray: Option<Array<Rune>> = v.toCharArray()
                return this.parse(charArray, separator)
        }
    }

    /**
     * parse the Char array
     *
     * @param charArray - Option<Array<Rune>> The char array need to parse
     * @param separator - Char The separator char
     * @return Map<String, Option<String>> - the result
     */
    public func parse(charArray: Option<Array<Rune>>, separator: Rune): Map<String, Option<String>> {
        match (charArray) {
            case None => return HashMap<String, Option<String>>()
            case Some(v) => return this.parse(charArray, 0, v.size, separator)
        }
    }

    /**
     * parse the Char array
     *
     * @param charArray - Option<Array<Rune>> The char array need to parse
     * @param offset - Int64 The offset
     * @param length - Int64 The length
     * @param separator - Char The separator char
     * @return Map<String, Option<String>> - the result
     */
    public func parse(charArray: Option<Array<Rune>>, offset: Int64, length: Int64, separator: Rune): Map<String, Option<String>> {
        match (charArray) {
            case None => return HashMap<String, Option<String>>()
            case Some(v) => this.chars = v
        }
        var params: HashMap<String, Option<String>> = HashMap<String, Option<String>>()

        this.pos = offset
        this.len = length
        var paramName: Option<String>
        var paramValue: Option<String>

        while (hasChar()) {
            paramName = parseToken(r'=', separator)
            paramValue = Option<String>.None
            if (hasChar() && charArray.getOrThrow()[pos] == r'=') {
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

            if (isParamName && (paramName.getOrThrow().toRuneArray().size > 0)) {
                if (lowerCaseNames) {
                    paramName = paramName.getOrThrow().toAsciiLower()
                }
                params.add(paramName.getOrThrow(), paramValue)
            }
        }
        return params
    }

    private func parseToken(ch1: Rune, ch2: Rune): Option<String> {
        this.i1 = this.pos
        this.i2 = this.pos
        while (hasChar()) {
            if (this.pos >= this.chars.size) {
                throw IndexOutOfBoundsException("offset is bigger than charArray size")
            }
            var ch: Rune = this.chars[this.pos]
            if (isOneOf(ch, ch1, ch2)) {
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
        if (quoted && ((i2 - i1) >= 2) && (chars[i1] == r'\"') && (chars[i2 - 1] == r'\"')) {
            i1++
            i2--
        }
        var result = Option<String>.None
        if (i2 > i1) {
            result = String(chars.slice(i1, i2 - i1))
            //result = String(chars, start: i1, length: i2 - i1)
        }
        return result
    }

    private func isOneOf(ch: Rune, ch1: Rune, ch2: Rune): Bool {
        return (ch == ch1 || ch == ch2)
    }

    private func isOneOf(ch: Rune, ch1: Rune): Bool {
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

    private func parseQuotedToken(terminators: Rune): Option<String> {
        i1 = pos
        i2 = pos
        var quoted: Bool = false
        var charEscaped: Bool = false

        while (hasChar()) {
            var ch: Rune = chars[pos]
            if (!quoted && this.isOneOf(ch, terminators)) {
                break
            }

            if (!charEscaped && ch == r'\"') {
                quoted = !quoted
            }

            charEscaped = (!charEscaped && ch == r'\\')
            i2++
            pos++
        }

        return this.getToken(true)
    }
}

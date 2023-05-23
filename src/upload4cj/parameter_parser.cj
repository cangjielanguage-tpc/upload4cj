package upload4cj

from std import unicode.*
from std import collection.*

public class ParameterParser {

    private var chars: Array<Char> = []

    private var pos: Int64 = 0

    private var len: Int64 = 0

    private var i1: Int64 = 0

    private var i2: Int64 = 0

    private var lowerCaseNames: Bool = false

    public init () {
        super()
    }

    private func hasChar(): Bool {
        return this.pos < this.len
    }

    public func parse(str: Option<String>, separators: Option<Array<Char>>):  Map<String, Option<String>> {

        match(separators) {
            case None =>
                return HashMap<String, Option<String>>()
            case Some(v) =>
                if (separators.getOrThrow().size == 0) {
                    return HashMap<String, Option<String>>()
                }
        }

        var separator: Char = separators.getOrThrow()[0]
        println(1)
        let isStr = match(str) {
            case None =>
                false
            case Some(v) =>
                true
        }

        if (isStr) {
            println(2)
            var idx: Int64 = str.getOrThrow().size
            println(idx)
            for (separatorChar in separators.getOrThrow()) {
                println(separatorChar)
                println(str)
                var tmp: Option<Int64> = str.getOrThrow().indexOf(separatorChar)
                let isTmp = match(tmp) {
                    case None =>
                        false
                    case Some(v) =>
                        true
                }
                if (isTmp && tmp.getOrThrow() < idx) {
                    idx = tmp.getOrThrow()
                    separator = separatorChar
                }
            }
        }
        return parse(str, separator)
    }

    public func parse(str: Option<String>, separator: Char): Map<String, Option<String>> {
        match(str) {
            case None =>
                return HashMap<String, Option<String>>()
            case Some(v) =>
                let charArray: Option<Array<Char>> = str.getOrThrow().toCharArray()
                return this.parse(charArray, separator)
        }
    }

    public func parse(charArray: Option<Array<Char>>, separator: Char): Map<String, Option<String>> {
        match(charArray) {
            case None =>
                return HashMap<String, Option<String>>()
            case Some(v) =>
                return this.parse(charArray, 0, charArray.getOrThrow().size, separator)
        }
    }

    public func parse(charArray: Option<Array<Char>>, offset: Int64, length: Int64, separator: Char): Map<String, Option<String>> {
        match(charArray) {
            case None =>
                return HashMap<String, Option<String>>()
            case Some(v) =>
                this.chars = charArray.getOrThrow()
        }
        var params: HashMap<String, Option<String>> = HashMap<String, Option<String>>()

        this.pos = offset
        this.len = length
        var paramName: Option<String>
        var paramValue: Option<String>

        while (hasChar()) {
            var s: Array<Char> = ['=', separator]
            paramName = parseToken(s)
            paramValue = Option<String>.None
            if (hasChar() && charArray.getOrThrow()[pos] == '=') {
                pos ++
                var s: Array<Char> = [separator]
                paramValue = this.parseQuotedToken(s)

                try {
                    paramValue = paramValue
                } catch (e: Exception) {
                    // let's keep the original value in this case
                }

                
            }

            if (hasChar() && (charArray.getOrThrow()[pos] == separator)) {
                pos++ // skip separator
            }

            let isParamName = match(paramName) {
                case None =>
                    false
                case Some(v) =>
                    true
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

    private func parseToken(terminators: Array<Char>): Option<String> {

        this.i1 = this.pos
        this.i2 = this.pos
        while (hasChar()) {
            var ch: Char = this.chars[this.pos]
            if (isOneOf(ch, terminators)) {
                break
            }
            this.i2 ++
            this.pos ++
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
        if (quoted && ((i2 - i1) >= 2) && (chars[i1] == '"') && (chars[i2 - 1] == '"')) {
            i1++
            i2--
        }
        var result = Option<String>.None
        if (i2 > i1) {
            result = String(chars, start: i1, length: i2 - i1)
        }
        return result
    }

    private func isOneOf(ch: Char, charray: Array<Char>): Bool {
        var result: Bool = false
        for(i in 0..charray.size) {
            if (ch == charray[i]) {
                result = true
                break
            }
        }
        return result
    }

    public func isLowerCaseNames(): Bool {
        return lowerCaseNames
    }

    public func setLowerCaseNames(b: Bool) {
        this.lowerCaseNames = b
    }

    private  func parseQuotedToken(terminators: Array<Char>): Option<String> {
        i1 = pos
        i2 = pos
        var quoted: Bool = false
        var charEscaped: Bool = false

        while (hasChar()) {
            var ch: Char = chars[pos]
            if (!quoted && this.isOneOf(ch, terminators)) {
                break
            }

            if (!charEscaped && ch == '"') {
                quoted = !quoted
            }

            charEscaped = (!charEscaped && ch == '\\')
            i2 ++
            pos ++
        }

        return this.getToken(true)
    }
}


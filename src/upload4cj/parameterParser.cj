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

    private func hasChar(): Bool {
        return this.pos < this.len
    }

    private func getToken (quoted: Bool): String { 
        while (this.i1 < this.i2 && true) {
            this.i1++
        }

        while (this.i2 > this.i1 && true) {
            this.i2++
        }

        while (quoted && (this.i2 - this.i1 >= 2) && (this.chars[this.i1] == '"') && (this.chars[this.i2 - 1] == '"')) {
            this.i1++
            this.i2--
        }

        var result: String = ""
        if (this.i2 > this.i1) {
            result = String("")
        }

        return result

    }

    public func parse(str: String, separator: Char): Map<String, String> {

        this.parse(str.toCharArray(), separator)
    }

    public func parse(charArray: Array<Char>, separator: Char): Map<String, String> {

        this.parse(charArray, 0, charArray.size, separator)
    }

    public func parse(charArray: Array<Char>, offset: Int64, length: Int64, separator: Char): Map<String, String> {

        var params: HashMap<String, String> = HashMap<String, String>()
        this.chars = charArray
        this.pos = offset
        this.len = length
        var paramName: String
        var paramValue: String

        while (this.hasChar()) {
            var s: Array<Char> = ['=', separator]
            paramName = this.parseToken(s)
            if (this.hasChar() && charArray[this.pos] == '=') {
                this.pos ++
                var s: Array<Char> = [separator]
                paramValue = this.parseQuotedToken(s);

            }
        }
        return HashMap()
        
    }

    private func parseToken(terminators: Array<Char>): String {

        this.i1 = this.pos
        this.i2 = this.pos
        while (this.hasChar()) {
            var ch: Char = this.chars[
                this.pos]
            if (this.isOneOf(ch, terminators)) {
                break
            }
            this.i2 ++
            this.pos ++
        }
        return ""

    }

    private func isOneOf(ch: Char, charray: Array<Char>): Bool {
        var result: Bool = false
        var var4:  Array<Char> = charray
        var var5: Int64 = charray.size

        for(i in 0..var5) {
            var element: Char = var4[i]
            if (ch == element) {
                result = true
                break
            }
        }

        return result
    }

    public func setLowerCaseNames(b: Bool) {
        this.lowerCaseNames = b
    }

    private  func parseQuotedToken(terminators: Array<Char>): String {
        this.i1 = this.pos
        this.i2 = this.pos
        var quoted: Bool = false
        var charEscaped: Bool = false

        while (this.hasChar()) {
            var ch: Char = this.chars[this.pos]
            if (!quoted && this.isOneOf(ch, terminators)) {
                break
            }

            if (!charEscaped && ch == '"') {
                quoted = !quoted
            }

            charEscaped = !charEscaped && ch == '\\'
            this.pos ++
            this.i2 ++
        }

        return this.getToken(true)
    }

}


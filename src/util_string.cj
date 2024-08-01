/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights resvered.
 */

package upload4cj

extend String {
    prop utf8View: Array<UInt8> {
        get() {
            this.toArray()
        }
    }
    func toUtf8Array(): Array<Byte> {
        this.toArray()
    }
    func toCharArray(): Array<Rune> {
        this.toRuneArray()
    }
    func equals(other: String): Bool {
        this == other
    }
    func substring(begin: Int64, length: Int64): String {
        this[begin..begin + length]
    }
    func substring(begin: Int64): String {
        this[begin..]
    }
    func indexOf(char: Rune): ?Int64 {
        this.indexOf(char.toString())
    }
    func lastIndexOf(char: Rune): ?Int64 {
        this.lastIndexOf(char.toString())
    }
    func contains(char: Rune): Bool {
        this.contains(char.toString())
    }
}

public class StringUtils {
    public static func indexOfStringReal(source: String, str: Option<String>, paraFromIndex: Int64): Option<Int64> {
        //先判断参数
        var fromIndex = paraFromIndex
        if (let Some(i) <- str) {
            if (fromIndex <= 0) {
                fromIndex = 0
            }
            //转成数组
            var runeArray: Array<Rune> = source.toRuneArray()
            if (runeArray.size == 0) {
                //为空字符串
                if (fromIndex > 0) {
                    return Option<Int64>.None
                } else {
                    return 0
                }
            }

            if (fromIndex >= runeArray.size) {
                return Option<Int64>.None
            }

            //先截取数组
            if (fromIndex != 0) {
                var sliceArray: Array<Rune> = runeArray.slice(fromIndex, runeArray.size - fromIndex)
                for (k in 0..sliceArray.size) {
                    if (sliceArray.get(k).getOrThrow().toString() == i) {
                        return k + fromIndex
                    }
                }
                return Option<Int64>.None
            } else {
                for (k in 0..runeArray.size) {
                    if (runeArray.get(k).getOrThrow().toString() == i) {
                        return k
                    }
                }
                return Option<Int64>.None
            }
        } else {
            //为空就返回
            return Option<Int64>.None
        }
    }
}


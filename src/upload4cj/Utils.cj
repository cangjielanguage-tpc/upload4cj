/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

/**
 * Streams
 */
public class Utils{

     public static  func indexOfRune(runes: Array<Rune>, sub: Array<Rune>, fromIndex!: Int64 = 0): ?Int64 {
        let len = sub.size
        for (i in fromIndex..=runes.size - len) {
            if (runes[i..i+len] == sub[..len]) {
                return i
            }
        }
        return None
    }
}

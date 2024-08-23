/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package upload4cj

extend Array<Rune> {
    func equalsIgnoreCase(other: Array<Rune>): Bool {
        if (this.size != other.size) {
            return false
        }
        for (i in 0..this.size where this[i].toAsciiLowerCase() != other[i].toAsciiLowerCase()) {
            return false
        }
        return true
    }

    func indexOfRuneArray(other: Array<Rune>, fromIndex: Int64): ?Int64 {
        let len = other.size
        for (i in fromIndex..=this.size - len) {
            if (this[i..i + len] == other) {
                return i
            }
        }
        return None
    }

    func indexOfRune(rune:Rune,fromIndex:Int64):?Int64{
        if(fromIndex >= this.size){
            return None
        }
        for(i in fromIndex..this.size){  
            if(this[i] == rune){
                return i
            }
        }
        return None
    }
}

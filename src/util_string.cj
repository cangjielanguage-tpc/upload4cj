/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights resvered.
 */

package upload4cj

extend String{
    prop utf8View: Array<UInt8> {
        get() {
            this.toArray()
        }
    }
    func toUtf8Array():Array<Byte>{
        this.toArray()
    }
    func toCharArray():Array<Rune>{
        this.toRuneArray()
    }
    func equals(other:String):Bool{
        this == other
    }
    func substring(begin:Int64,length:Int64):String{
        this[begin..begin+length]
    }
    func substring(begin:Int64):String{
        this[begin..]
    }
    func indexOf(char:Rune):?Int64{
        this.indexOf(char.toString())
    }
    func lastIndexOf(char:Rune):?Int64{
        this.lastIndexOf(char.toString())
    }
    func contains(char:Rune):Bool{
        this.contains(char.toString())
    }








}

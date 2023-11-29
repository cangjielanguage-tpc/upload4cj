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
    func indexOf(char:Char):?Int64{
        this.indexOf(char.toString())
    }
    func lastIndexOf(char:Char):?Int64{
        this.lastIndexOf(char.toString())
    }
    func contains(char:Char):Bool{
        this.contains(char.toString())
    }

    // func indexOfSelf(char:Char):?Int64{
    //    let runeArr:Array<Rune> = this.toRuneArray()
    //    for(i in 0..runeArr.size){
    //         if(char == runeArr[i]){
    //             return Option<Int64>.Some(i)
    //         }
    //    }
    //    return Option<Int64>.None
    // }

    // func indexOfSelf(char:Char,fromIndex:Int64):?Int64{
    //    let runeArr:Array<Rune> = this.toRuneArray()
    //    if(fromIndex >= runeArr.size){
    //         return Option<Int64>.None
    //    }
    //    for(i in fromIndex..runeArr.size){
    //         if(char == runeArr[i]){
    //             return Option<Int64>.Some(i)
    //         }
    //    }
    //    return Option<Int64>.None
    // }

    //bsd

    //asdbsdadas

    func indexOfSelf(str:String):?Int64{
        let offset:Option<Int64> = this.indexOf(str)
        if(let Some(i) <- offset){
            return this[0..i].toRuneArray().size
        }else{
            return Option<Int64>.None
        }
    }






}

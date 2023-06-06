package upload4cj

public abstract class LimitedInputStream <: InputStream{

    /**
     * The input stream to be filtered.
     */
    private let input:InputStream

     /**
     * The maximum size of an item, in bytes.
     */
    private let sizeMax:Int64


    /**
     * The current number of bytes.
     */
    private var count:Int64 = 0


    public init(inputStream:InputStream,pSizeMax:Int64){
        this.input = inputStream
        this.sizeMax = pSizeMax
    }

    protected func raiseError(pSizeMax:Int64,pCount:Int64):Unit

    private func checkLimit():Unit{
        if (count > sizeMax) {
            raiseError(sizeMax, count)
        }
    }


    public override func read(buffer:Array<UInt8>):Int64{
        let res:Int64 = input.read(buffer)
        if (res > 0) {
            count += res
            checkLimit()
        }
        return res
    }


}

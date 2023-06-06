package upload4cj

public class LimitedInputStreamImpl <: LimitedInputStream{


    public init(inputStream:InputStream,pSizeMax:Int64){
       super(inputStream,pSizeMax)
    }

    protected override func raiseError(pSizeMax:Int64,pCount:Int64):Unit{
        throw  SizeLimitExceededException("the request was rejected because its size "+pCount.toString()+" exceeds the configured maximum "+pSizeMax.toString())
    }


}

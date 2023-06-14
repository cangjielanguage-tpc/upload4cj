package upload4cj

public class LimitedInputStreamImpl2 <: LimitedInputStream {
    public init(inputStream: InputStream, pSizeMax: Int64) {
        super(inputStream, pSizeMax)
    }

    protected override func raiseError(pSizeMax: Int64, pCount: Int64): Unit {
        throw FileSizeLimitExceededException("The field exceeds its maximum permitted size of "+ pSizeMax.toString() +" bytes. actual "+pCount.toString())
    }
}

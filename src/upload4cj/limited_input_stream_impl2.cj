package upload4cj

public class LimitedInputStreamImpl2 <: LimitedInputStream {
    private var itemStream: ItemInputStream

    public init(inputStream: InputStream, pSizeMax: Int64, stream: ItemInputStream) {
        super(inputStream, pSizeMax)
        this.itemStream = stream
    }

    protected override func raiseError(pSizeMax: Int64, pCount: Int64): Unit {
        itemStream.close(true)
        throw FileSizeLimitExceededException(
            "The field exceeds its maximum permitted size of " + pSizeMax.toString() + " bytes. actual " +
                pCount.toString()
        )
    }
}

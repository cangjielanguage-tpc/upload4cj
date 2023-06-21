package upload4cj

public class LimitedInputStreamImpl <: LimitedInputStream {
    private var itemStream: Option<ItemInputStream>

    public init(inputStream: InputStream, pSizeMax: Int64, stream: Option<ItemInputStream>) {
        super(inputStream, pSizeMax)
        this.itemStream = stream
    }

    protected override func raiseError(pSizeMax: Int64, pCount: Int64): Unit {
        if (let Some(i) = itemStream) {
            i.close(true)
            throw FileSizeLimitExceededException(
                "The field exceeds its maximum permitted size of " + pSizeMax.toString() + " bytes. actual " +
                    pCount.toString())
        } else {
            throw SizeLimitExceededException(
                "the request was rejected because its size " + pCount.toString() + " exceeds the configured maximum " +
                    pSizeMax.toString()
            )
        }
    }
}

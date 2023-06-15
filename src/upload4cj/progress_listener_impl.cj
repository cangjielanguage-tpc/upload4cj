package upload4cj

public class ProgressListenerImpl <: ProgressListener{

    private let expectedContentLength: Int64

    private let expectedItems: Int64

    private var bytesRead: Int64 = 0

    private var items: Int64 = 0

    public init(pContentLength: Int64, pItems: Int64) {
        expectedContentLength = pContentLength
        expectedItems = pItems
    }

    public override func update(pBytesRead: Int64, pContentLength: Int64, pItems: Int64) {
        bytesRead = pBytesRead
        items = pItems
    }

    public func checkFinished (): Unit {

    }




}

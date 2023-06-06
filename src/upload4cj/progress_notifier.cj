package upload4cj

public class ProgressNotifier {

    private let listener: Option<ProgressListener>

    private let contentLength: Int64

    private var bytesRead: Int64 = -1

    private var items: Int64 = -1

    public init(pListener: Option<ProgressListener>, pContentLength: Int64) {
        listener = pListener
        contentLength = pContentLength
    }

    public func noteBytesRead(pBytes: Int64) {
        bytesRead = bytesRead + pBytes
        notifyListener()
    }

    func noteItem():Unit{
        items++
        notifyListener()
    }

    private func notifyListener() {
        if(let Some(i) = listener){
            i.update(bytesRead, contentLength, items)
        }
    }

}

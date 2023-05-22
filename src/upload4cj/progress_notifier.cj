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

    private func notifyListener() {
        
        let islistener = match (listener) {
            case Some(v) => true
            case None => false
        }
        
        if (!islistener) {
            listener.getOrThrow().update(bytesRead, contentLength, items);
        }
    }

}

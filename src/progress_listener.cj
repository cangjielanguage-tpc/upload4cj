package cangjie_tpc::upload4cj

/**
 * ProgressListener
 */
public interface ProgressListener {
    func update(pBytesRead: Int64, pContentLength: Int64, pItems: Int64): Unit
}

package cangjie_tpc::upload4cj

/**
 * FileItemHeadersSupport
 */
public interface FileItemHeadersSupport {
    func getHeaders(): FileItemHeaders

    func setHeaders(headers: FileItemHeaders): Unit
}

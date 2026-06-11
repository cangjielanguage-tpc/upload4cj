package cangjie_tpc::upload4cj

/**
 * FileItemHeaders
 */
public interface FileItemHeaders {
    func getHeader(name: String): Option<String>

    func getHeaders(name: String): Iterator<String>

    func getHeaderNames(): Iterator<String>
}

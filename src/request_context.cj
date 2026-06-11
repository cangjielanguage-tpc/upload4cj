package cangjie_tpc::upload4cj

/**
 * RequestContext
 */
public interface RequestContext {
    func getCharacterEncoding(): Option<String>

    func getContentType(): Option<String>

    func contentLength(): Int64

    func getInputStream(): InputStream
}

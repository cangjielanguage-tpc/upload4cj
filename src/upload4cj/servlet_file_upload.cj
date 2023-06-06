package upload4cj

public class ServletFileUpload <: FileUpload {
    private static let POST_METHOD: String = "POST"

    public init() {
        super()
    }

    public init(fileItemFactory: FileItemFactory) {
        super(fileItemFactory)
    }

    public func parseParameterMap(request: Request): Map<String, ArrayList<FileItem>> {
        return parseParameterMap(ServletRequestContext(request))
    }

    public func parseRequest(request: Request): Option<ArrayList<FileItem>> {
        return parseRequest(ServletRequestContext(request))
    }
}

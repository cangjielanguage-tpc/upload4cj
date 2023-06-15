package upload4cj

public class ServletFileUpload <: FileUpload {
    private static let POST_METHOD: String = "POST"

    public static func isMultipartContent(request: Request):Bool{
        let requestMethod:String = request.method.toString().toAsciiLower()
        let lowerPost = POST_METHOD.toAsciiLower()
        if(!lowerPost.equals(requestMethod)){
            return false
        }
        return FileUploadBase.isMultipartContent(ServletRequestContext(request))
    }

    public init() {
        super()
    }

    public init(fileItemFactory: FileItemFactory) {
        super(fileItemFactory)
    }

    public func parseRequest(request: Request): Option<ArrayList<FileItem>> {
        return parseRequest(ServletRequestContext(request))
    }

    public func parseParameterMap(request: Request): Map<String, ArrayList<FileItem>> {
        return parseParameterMap(ServletRequestContext(request))
    }

    public func getItemIterator(request:Request):FileItemIterator{
        return getItemIterator(ServletRequestContext(request))
    }
}

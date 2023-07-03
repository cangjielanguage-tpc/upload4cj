/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

/**
 * ServletFileUpload
 */
public class ServletFileUpload <: FileUpload {
    private static let POST_METHOD: String = "POST"

    /**
     * is Multipart or not
     *
     * @param request - Request The Request
     * @return Bool - is Multipart or not
     */
    public static func isMultipartContent(request: Request): Bool {
        let requestMethod: String = request.method.toString().toAsciiLower()
        let lowerPost = POST_METHOD.toAsciiLower()
        if (!lowerPost.equals(requestMethod)) {
            return false
        }
        return FileUploadBase.isMultipartContent(ServletRequestContext(request))
    }

    /**
     * init
     */
    public init() {
        super()
    }

    /**
     * init
     *
     * @param fileItemFactory - FileItemFactory The FileItemFactory
     */
    public init(fileItemFactory: FileItemFactory) {
        super(fileItemFactory)
    }

    /**
     * parse the Request
     *
     * @param request - Request The Request
     * @return Option<ArrayList<FileItem>> - the FileItem ArrayList that parsed
     */
    public func parseRequest(request: Request): Option<ArrayList<FileItem>> {
        return parseRequest(ServletRequestContext(request))
    }

    /**
     * parse parameterMap
     *
     * @param request - Request The Request
     * @return Map<String, ArrayList<FileItem>> - the FileItem map that parsed
     */
    public func parseParameterMap(request: Request): Map<String, ArrayList<FileItem>> {
        return parseParameterMap(ServletRequestContext(request))
    }

    /**
     * get FileItemIterator
     *
     * @param request - Request The Request
     * @return FileItemIterator - the FileItemIterator
     */
    public func getItemIterator(request: Request): FileItemIterator {
        return getItemIterator(ServletRequestContext(request))
    }
}

package upload4cj

from net import http.*

public class ServletRequestContext <: RequestContext {
    private var request: Request

    public init(request: Request) {
        this.request = request
    }

    public override func getCharacterEncoding(): Option<String> {
        return FileUploadBase.CHARACTER_ENCODING
    }

    public override func getContentType(): Option<String> {
        return request.header.get(FileUploadBase.CONTENT_TYPE)
    }

    public override func contentLength(): Int64 {
        var size: Int64
        try {
            let contentLength: String = request.header.get(FileUploadBase.CONTENT_LENGTH).getOrThrow()
            size = Int64.parse(contentLength)
        } catch (e: Exception) {
            size = request.contentLength
        }
        return size
    }

    public override func getInputStream(): InputStream {
        return request.body
    }

    public func toString(): String {
        return "ContentLength = ${this.contentLength()}, ContentType = ${this.getContentType()}"
    }
}

package upload4cj

from net import http.*

public class ServletRequestContext <: UploadContext {
    private var request: Request

    public init(request: Request) {
        this.request = request
    }

    public override func getCharacterEncoding(): Option<String> {
        return Option<String>.None
    }

    public override func getContentType(): Option<String> {
        return request.header.get(FileUploadBase.CONTENT_TYPE)
    }

    public override func getContentLength(): Int64 {
        return request.contentLength
    }

    public override func contentLength(): Int64 {
        var size: Int64
        try {
            size = Int64.parse(request.header.get(FileUploadBase.CONTENT_LENGTH).getOrThrow())
        } catch (e: IllegalArgumentException) {
            size = request.contentLength
        }
        return size
    }

    public override func getInputStream(): InputStream {
        return request.body
    }

    public func toString(): String {
        return ""
    }
}

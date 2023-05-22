package upload4cj

from net import http.*

public class ServletRequestContext <: UploadContext {

    private var request: Request

    public init(request: Request){
        this.request = request
    }

    public override func getCharacterEncoding(): String {
        return ""
    }

    public override func getContentType(): String {
        return ""
    }

    public override func getContentLength(): Int64 {
        return 0
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
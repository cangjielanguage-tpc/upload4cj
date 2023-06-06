package upload4cj

public interface UploadContext <: RequestContext {
    func contentLength(): Int64
}

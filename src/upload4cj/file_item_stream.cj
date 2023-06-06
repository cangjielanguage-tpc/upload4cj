package upload4cj

public interface FileItemStream <: FileItemHeadersSupport{


    func openStream():InputStream

    func getContentType():String

    func getName():Option<String>

    func getFieldName():String

    func isFormField():Bool

}

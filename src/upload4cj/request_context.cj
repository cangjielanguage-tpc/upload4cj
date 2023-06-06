package upload4cj


public interface RequestContext {

    func getCharacterEncoding():Option<String>

    func getContentType():Option<String>

    func getContentLength():Int64

    func getInputStream():InputStream


}

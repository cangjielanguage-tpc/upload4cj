package upload4cj


public interface RequestContext {

    func getCharacterEncoding():String

    func getContentType():String

    func getContentLength():Int64

    func getInputStream():InputStream


}
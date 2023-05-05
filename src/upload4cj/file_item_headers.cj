package upload4cj

public interface FileItemHeaders{

    func getHeader(name:String):String

    func getHeaders(name:String):Iterator<String>

    func getHeaderNames():Iterator<String>

}

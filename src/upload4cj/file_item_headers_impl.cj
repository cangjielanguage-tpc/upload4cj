package upload4cj

public class FileItemHeadersImpl <: FileItemHeaders {

    public override func getHeader(name:String): String{
        return ""
    }

    public override func getHeaders(name:String): Iterator<String>{
        return ArrayList<String>(["2", "3"]).iterator()
    }

    public override func getHeaderNames(): Iterator<String>{
        return ArrayList<String>(["2", "3"]).iterator()
    }


}
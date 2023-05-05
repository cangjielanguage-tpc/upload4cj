package upload4cj.disk

from std import collection.*


public class FileItemHeadersImpl <: FileItemHeaders {

    init(){}

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
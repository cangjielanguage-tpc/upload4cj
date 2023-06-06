package upload4cj

public class FileItemHeadersImpl <: FileItemHeaders {

    private let headerNameToValueListMap:Map<String, ArrayList<String>> = HashMap<String, ArrayList<String>>()

    public override func getHeader(name:String): Option<String> {
        let nameLower:String =  name.toAsciiLower()
        let headerValueList:Option<ArrayList<String>> = headerNameToValueListMap.get(nameLower)
        if(let Some(i) = headerValueList){
            return i.get(0)
        }else{
            return Option<String>.None
        }
    }

    public override func getHeaderNames(): Iterator<String>{
        return headerNameToValueListMap.keys().iterator()
    }

    public override func getHeaders(name:String): Iterator<String>{
        let nameLower:String =  name.toAsciiLower()
        var headerValueList:Option<ArrayList<String>> = headerNameToValueListMap.get(nameLower)
        if(let Some(i) = headerValueList){
            return i.iterator()
        }else{
            headerValueList = ArrayList<String>()
            return headerValueList.getOrThrow().iterator()
        }
    }

    public func addHeader(name:String,value:String):Unit{
        let nameLower:String =  name.toAsciiLower()
        var headerValueList:Option<ArrayList<String>> = headerNameToValueListMap.get(nameLower)
        if(let Some(i) = headerValueList){
        }else{
            headerValueList = ArrayList<String>()
            headerNameToValueListMap.put(nameLower, headerValueList.getOrThrow())
        }
        headerValueList.getOrThrow().append(value)
    }

}

// 3rd_party_lib:upload4cj/build/upload4cj
// data_file: RequestBody_MB10

import upload4cj.*
import std.fs.*
import std.io.*
import std.math.*
import std.time.*
import std.collection.*
import stdx.net.http.*

main() {
    let threadCount = 200
    let loopCount = 1000
    let futures = ArrayList<Future<ArrayList<String>>>()
    let start = DateTime.now()
    for (_ in 0..threadCount) {
        var thread :Future<ArrayList<String>>= spawn {
            var result=ArrayList<String>()
            for (_ in 0..loopCount) {
                try {
                    let reFlag=testParseParameterMap()
                    if(reFlag==1){//1是预期结果
                        result.append("success")
                    }else{
                        result.append("fail")
                    }
                } catch (e: Exception) {
                    result.append(e.message)
                    continue
                    // break
                    // Process.atexit({()=>println("got err ${e.message}")})
                    // Process.exit()
                }
            }
            return result
        }
        futures.append(thread)
    }
    for (f in futures) {
        f.get()
    }
    let end = Duration.since(start).toSeconds()
    var count_fail=0
    for (f in futures){
        var temp_re=f.get()
        for (j in temp_re){
            if(j!="success"){
                count_fail+=1
            }
        }
    }
    println("test_upload_parseParameterMap_MB10_${threadCount}*${loopCount} TPS: ${Int64((threadCount*loopCount)/end)} FailRate: ${count_fail/(threadCount*loopCount)*100} %")
}
public func testParseParameterMap():Int64 {
    let file=File("./RequestBody_MB10",OpenOption.Open(true,false))
    let bytes: Array<UInt8> = file.readToEnd()
    var output = ByteBuffer()
    output.write(bytes)
    var req1= HttpRequestBuilder.new().method("POST").url("http://127.0.0.1/").body(output).build()
    req1.headers.add("Content-Type", "multipart/form-data; boundary=---1234")
    let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
    let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)
    let vs = mappedParameters.values()
    for(v in vs){
        for(item in v){
            item.delete()
        }
    }
    return mappedParameters.size
}
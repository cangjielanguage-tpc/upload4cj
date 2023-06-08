// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

main(){
        let CONTENT_TYPE:String = "multipart/form-data; boundary=---1234"
        let text = "-----1234\r\nContent-Disposition: form-data; name=\"file\";filename=\"foo.tab\"\r\nContent-Type: text/whatever\r\n\r\nThis is the content of the file oo\n\r\n-----1234--\r\n"
        let bytes:Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
        req1.header.add("Content-Type",CONTENT_TYPE)
        let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory(0,Option<Directory>.None))
        let items:ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        if(items.size == 1){
            println("Pass3")
        }
        let item0:FileItem = items.get(0).getOrThrow()

        let filePath:Path = Path("./uploadtest2temp")
        let file = File(filePath,OpenOption.Create(true))
        if(!File.exists(file.info.path)){
            File.create(file.info.path)
        }
        item0.write(file)
        return 0
}



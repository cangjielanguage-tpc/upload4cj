package upload4cj.disk

import upload4cj.*
from std import fs.*
from std import io.*

public class DiskFileItem <: FileItem {

    init(){

    }

    public override func getInputStream(): InputStream{
        return ByteArrayStream()
    }

    public override func getContentType(): String {
        return ""
    }

    public override func getName(): String {
        return ""
    }

    public override func isInMemory(): Bool {
        return true
    }

    public override func getSize(): Int64 {
        return Int64(3)
    }

    public override func get(): Array<UInt8> {
        return Array<UInt8>(10, item: 0)
    }

    public override func getString(encoding: String): String {
        return ""
    }

    public override func getString(): String {
        return ""
    }

    public override func write(file:File) {
        return 
    }

    public override func delete() {
        return 
    }

    public override func getFieldName(): String {
        return ""
    }

    public override func setFieldName(name: String) {
        return 
    }

    public override func isFormField(): Bool {
        return true
    }

    public override func setFormField(state: Bool){
        return 
    }

    public override func getOutputStream(): OutputStream{
        return ByteArrayStream()
    }

    public override func getHeaders(): FileItemHeaders{
        return FileItemHeadersImpl()
    }

    // func setHeaders(headers:FileItemHeaders):Unit

    public override func setHeaders(headers: FileItemHeaders) {
        return 
    }

}

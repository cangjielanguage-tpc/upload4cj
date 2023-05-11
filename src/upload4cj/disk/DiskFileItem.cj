package upload4cj.disk

import upload4cj.*
from std import fs.*
from std import io.*

public class DiskFileItem <: FileItem {

    private static let DEFAULT_CHARSET: String = "ISO-8859-1"

    private static let UID: String = "uuid"

    private static var COUNTER: Int64 = 0

    private var fieldName: String

    private var contentType: String

    private var isFormField: Bool
    private var fileName: String

    private var size: Int64 = -1 

    private var sizeThreshold: Int32

    private var repository: File

    private var cachedContent = Option<Array<UInt8>>.None

    private var dfos: DeferredFileOutputStream = DeferredFileOutputStream(0)

    private var tempFile: File = File("33", OpenOption.Open(true, true))

    private var headers: FileItemHeaders = FileItemHeadersImpl()

    private var defaultCharset: String = "ISO-8859-1"

    init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int32, repository: File) {
        this.fieldName = fieldName
        this.contentType = contentType
        this.isFormField = isFormField
        this.fileName = fileName
        this.sizeThreshold = sizeThreshold
        this.repository = repository
    }

    public override func getInputStream(): InputStream{
        if (!this.isInMemory()) {
            var c = ByteArrayStream()
            c.write(this.cachedContent.getOrThrow())
            return c
        } else {
            cachedContent = match (cachedContent) {
                case Some(v) => cachedContent
                case None => this.dfos.getData()
            }
            var b = ByteArrayStream()
            b.write(this.cachedContent.getOrThrow())
            return b

        }
    }

    public override func getContentType(): String {
        return this.contentType
    }

    public func getCharSet(): String {
        var parse: ParameterParser = ParameterParser()
        parse.setLowerCaseNames(true)
        parse.parse(this.getContentType(), ';')


        return this.contentType
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

    public func isGetFormField(): Bool {
        return this.isFormField
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

    public override func setHeaders(headers: FileItemHeaders) {
        return 
    }

}

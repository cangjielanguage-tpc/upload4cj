package upload4cj

from std import io.*
from std import random.*

public class DiskFileItem <: FileItem {

    public static let DEFAULT_CHARSET: String = "ISO-8859-1"

    private static let UID: String = "uuid"

    private static var COUNTER: Int64 = 0

    private var fieldName: String

    private var contentType: String

    private var isFormField: Bool

    private var fileName: String

    private var size: Int64 = -1

    public var sizeThreshold: Int64

    private var repository = Option<Directory>.None

    private var cachedContent = Option<Array<UInt8>>.None

    private var dfos: ?DeferredFileOutputStream = Option<DeferredFileOutputStream>.None

    private var tempFile = Option<File>.None

    private var headers: FileItemHeaders = FileItemHeadersImpl()

    private var defaultCharset:String = DEFAULT_CHARSET

    init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int64, repository: Option<Directory>) {
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
                case None => this.dfos.getOrThrow().getData()
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
        return Streams.checkFileName(this.fileName)
    }

    public override func isInMemory(): Bool {
        if(let Some(i) = cachedContent){
            return true
        }
        return this.dfos.getOrThrow().isInMemory()
    }

    public override func getSize(): Int64 {
        if (this.size >= 0) {
            return this.size
        }

        let InMemory = match (cachedContent) {
            case Some(v) => this.cachedContent.getOrThrow().size
            case None => 0
        }

        if (InMemory != 0) {
            return InMemory
        }

        if (this.dfos.getOrThrow().isInMemory()) {
            return this.dfos.getOrThrow().getData().getOrThrow().size
        }

        return this.dfos.getOrThrow().getFile().length
    }

    public override func get(): Option<Array<UInt8>> {
        if (this.isInMemory()) {
            let isCachedContent = match (cachedContent) {
                case Some(v) => true
                case None => false
            }

            let isDfos = match (dfos) {
                case Some(v) => true
                case None => false
            }

            if (!isCachedContent && isDfos) {
                this.cachedContent = this.dfos.getOrThrow().getData()
            }
            return this.cachedContent
        }

        var fileData: Option<Array<UInt8>> = Array<UInt8>(this.getSize(), item: 0)
        // read file to Array<Unit8>
        try {
            this.dfos.getOrThrow().getFile().read(fileData.getOrThrow())
        } catch (ie: Exception) {
            return  Option<Array<UInt8>>.None
        }
        return fileData

    }

    public override func getString(): String {
        let s = get().getOrThrow()
        var charArray: Array<Char> = Array<Char>(s.size, item: Char(0))
        for( i in 0..s.size) {
            // uint8 -> char
           charArray[i] = Char(s[i])
        }
        return String(charArray)
    }

    public override func write(file:File) {
        if (isInMemory()) {
            try {
                file.write(get().getOrThrow())
            } catch (ie: FSException) {
                throw FileWriteException("fail to write")
            }

        } else {

            var outputFile: Option<File> = getStoreLocation()

            let isOutputFile = match (outputFile) {
                case Some(v) => true
                case None => false
            }

            if (isOutputFile) {
                // Save the length of the file
                size = outputFile.getOrThrow().length
                /*
                 * The uploaded file is being stored on disk
                 * in a temporary location so move it to the
                 * desired file.
                 */
                // FileUtils.moveFile(outputFile, file)
            } else {
                /*
                 * For whatever reason we cannot write the
                 * file to disk.
                 */
                throw FileUploadException(
                    "Cannot write uploaded file to disk!")
            }

        }

        return
    }

    public override func delete() {
        cachedContent = Option<Array<UInt8>>.None
        var outputFile: Option<File> = getStoreLocation()

        let isOutputFile = match (outputFile) {
            case Some(v) => true
            case None => false
        }

        if (isOutputFile && !isInMemory() && File.exists(outputFile.getOrThrow().info.path)) {
            File.delete(outputFile.getOrThrow().info.path)
        }
    }

    public override func getFieldName(): String {
        return fieldName
    }

    public override func setFieldName(fieldName: String) {
        this.fieldName = fieldName
    }

    public func isGetFormField(): Bool {
        return this.isFormField
    }

    public override func setFormField(state: Bool){
        isFormField = state
    }

    public override func getOutputStream(): OutputStream{

        let isDfos = match (dfos) {
            case Some(v) => true
            case None => false
        }
        if (!isDfos) {
            var outputFile: File = getTempFile()
            dfos = DeferredFileOutputStream(sizeThreshold, outputFile)
        }

        return dfos.getOrThrow()
    }

    public override func getHeaders(): FileItemHeaders{
        return headers
    }

    public override func setHeaders(pHeaders: FileItemHeaders) {
        this.headers = pHeaders
    }

    public func getStoreLocation(): Option<File> {
        let isDfos = match (dfos) {
            case Some(v) => true
            case None => false
        }

        if (!isDfos) {
            return Option<File>.None
        }
        if (isInMemory()) {
            return Option<File>.None
        }

        let fileName: Option<File> = dfos.getOrThrow().getFile()
        return fileName
    }

    protected func getTempFile(): File {
        if(let Some(i) = tempFile){
            return i
        }else{
            var tempDir:Option<Directory> = repository
            let tempFileName:String = "upload_"+generateId()+".tmp"
            if(let Some(j) = tempDir){
            }else{
                let dirName = "tempDir"+generateId()
                if(!Directory.exists(dirName)){
                    tempDir =  Directory.create(dirName)
                }
            }
            let path: Path = tempDir.getOrThrow().info.path.join(tempFileName)
            tempFile = File(path, OpenOption.Create(true))
        }
        return tempFile.getOrThrow()

    }

       private func generateId():String{
        var array: Array<String> = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        var strbuilder = StringBuilder()
        let size = array.size
        let sizeDouble = Float64(size)
        var m: Random = Random()
        for(i in 0..16){
           let doubleValue = m.nextFloat64()
           let value = doubleValue * sizeDouble
           let IntValue = Int64(value)
           let chooseStr = array[IntValue]
           strbuilder.append(chooseStr)
        }
        return strbuilder.toString()
    }


    public func getDefaultCharset():String{
        return defaultCharset
    }

    public func setDefaultCharset(charset:String):Unit{
        defaultCharset = charset
    }


}

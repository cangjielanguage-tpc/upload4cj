package upload4cj

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

    private var sizeThreshold: Int64

    private var repository = Option<File>.None

    private var cachedContent = Option<Array<UInt8>>.None

    private var dfos: ?DeferredFileOutputStream = Option<DeferredFileOutputStream>.None

    private var tempFile = Option<File>.None

    private var headers: FileItemHeaders = FileItemHeadersImpl()

    private var defaultCharset: String = "ISO-8859-1"

    init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int64, repository: Option<File>) {
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

        let InMemory = match (cachedContent) {
            case Some(v) => true
            case None => this.dfos.getOrThrow().isInMemory()
        }
        return InMemory
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
                throw FSException("fail to write")
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
        return FileItemHeadersImpl()
    }

    public override func setHeaders(headers: FileItemHeaders) {
        return 
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

        let isTempFile = match (tempFile) {
            case Some(v) => true
            case None => false
        }

        if (!isTempFile) {

            let tempDir: Option<File> = match (repository) {
                case Some(v) => repository
                case None => File("/tempDir", OpenOption.Create(true))
            }
            let path: Path = tempDir.getOrThrow().info.path.directoryName.getOrThrow().join("a.temp")

            tempFile = File(path, OpenOption.Create(true))
        }
        return tempFile.getOrThrow()
    }

}

package upload4cj

from std import io.*
from std import random.*
from uuid import uuid.*
from std import sync.*

public class DiskFileItem <: FileItem {
    public static let DEFAULT_CHARSET: String = "UTF-8"

    private static let UID: String = Generators.randomBasedGenerator().generate().toString().replace('-', '_')

    private static let COUNTER = AtomicInt64(0)

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

    private var defaultCharset: String = DEFAULT_CHARSET

    public init(
        fieldName: String,
        contentType: String,
        isFormField: Bool,
        fileName: String,
        sizeThreshold: Int64,
        repository: Option<Directory>
    ) {
        this.fieldName = fieldName
        this.contentType = contentType
        this.isFormField = isFormField
        this.fileName = fileName
        this.sizeThreshold = sizeThreshold
        this.repository = repository
    }

    public override func getInputStream(): InputStream {
        if (!this.isInMemory()) {
            return this.dfos.getOrThrow().getFile()
        } else {
            if (let Some(i) = cachedContent) {}
            else {
                cachedContent = this.dfos.getOrThrow().getData()
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
        let params: Map<String, Option<String>> = parse.parse(this.getContentType(), ';')
        return params.get("charset").getOrThrow().getOrThrow()
    }

    public override func getName(): String {
        return Streams.checkFileName(this.fileName).getOrThrow()
    }

    public override func isInMemory(): Bool {
        if (let Some(i) = cachedContent) {
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
        return this.dfos.getOrThrow().getFile().info.length
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
            this.dfos.getOrThrow().getFile().seek(SeekPosition.Begin(0))
            this.dfos.getOrThrow().getFile().read(fileData.getOrThrow())
        } catch (ie: Exception) {
            return Option<Array<UInt8>>.None
        }
        return fileData
    }

    public override func getString(): String {
        let s = get().getOrThrow()
        return String.fromUtf8(s)
    }

    public override func write(file: File) {
        if (isInMemory()) {
            try {
                file.write(get().getOrThrow())
            } catch (ie: FSException) {
                throw ParseException("fail to write")
            }
        } else {
            var outputFile: Option<File> = getStoreLocation()

            let isOutputFile = match (outputFile) {
                case Some(v) => true
                case None => false
            }

            if (isOutputFile) {
                // Save the length of the file
                size = outputFile.getOrThrow().info.length
                file.write(get().getOrThrow())
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
                throw FileUploadException("Cannot write uploaded file to disk!")
            }
        }

        return
    }

    public override func delete() {
        cachedContent = Option<Array<UInt8>>.None
        var outputFile: Option<File> = getStoreLocation()

        let isOutputFile = match (outputFile) {
            case Some(v) =>
                v.close()
                true
            case None => false
        }

        if (isOutputFile && File.exists(outputFile.getOrThrow().info.path)) {
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

    public override func setFormField(state: Bool) {
        isFormField = state
    }

    public override func getOutputStream(): OutputStream {
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

    public func getStoreLocation(): Option<File> {
        let isDfos = match (dfos) {
            case Some(v) => true
            case None => false
        }

        if (!isDfos) {
            return Option<File>.None
        }

        let fileName: Option<File> = dfos.getOrThrow().getFile()
        return fileName
    }

    protected func getTempFile(): File {
        if (let Some(i) = tempFile) {
            return i
        } else {
            var tempDir: Option<Directory> = repository
            let dirName = "tempDir"
            var pathDir: Path = Path(dirName)
            if (let Some(j) = tempDir) {
                pathDir = j.info.path
            } else {
                if (!Directory.exists(pathDir)) {
                    tempDir = Directory.create(pathDir)
                }
            }
            let tempFileName: String = "upload_" + UID + getUniqueId() + ".tmp"
            let path: Path = pathDir.join(tempFileName)
            tempFile = File(path, OpenOption.Create(true))
        }
        return tempFile.getOrThrow()
    }

    private static func getUniqueId(): String {
        let limit: Int64 = 100000000
        let current: Int64 = COUNTER.fetchAdd(1)
        var id: String = current.toString()
        if (current < limit) {
            id = ("00000000" + id).substring(id.size)
        }
        return id
    }

    public func toString(): String {
         if (let Some(i) = getStoreLocation()) {
            return "name=" + getName() + " StoreLocation=" + getStoreLocation().getOrThrow().info.path.toString() + " size="+getSize().toString() + " bytes isFormField=" + isGetFormField().toString() + " FieldName=" +getFieldName()
        } else {
            return "name=" + getName() + " size=" + getSize().toString() + " bytes isFormField=" + isGetFormField().toString() + " FieldName=" + getFieldName()
        }
    }

    public override func getHeaders(): FileItemHeaders {
        return headers
    }

    public override func setHeaders(pHeaders: FileItemHeaders) {
        this.headers = pHeaders
    }

    public func getDefaultCharset(): String {
        return defaultCharset
    }

    public func setDefaultCharset(charset: String): Unit {
        defaultCharset = charset
    }
}

/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

from std import io.*
from std import random.*
from uuid4cj import uuid4cj.*
from std import sync.*

/**
 * create DiskFileItem
 */
public class DiskFileItem <: FileItem {
    public static let DEFAULT_CHARSET: String = "UTF-8"

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

    /**
     * init
     *
     * @param fieldName - String The fieldName
     * @param contentType - String The contentType
     * @param isFormField - Bool The isFormField
     * @param fileName - String The fileName
     * @param sizeThreshold - Int64 The sizeThreshold
     * @param repository - Option<Directory> The repository
     */
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

    /**
     * get the InputStream
     *
     * @return Option<InputStream> - The InputStream
     */
    public override func getInputStream(): Option<InputStream> {
        if (!this.isInMemory()) {
            let optFile: Option<File> = this.dfos.getOrThrow().getFile()
            if (let Some(j) = optFile) {
                return j
            } else {
                return Option<InputStream>.None
            }
        } else {
            if (let Some(_) = cachedContent) {}
            else {
                cachedContent = this.dfos.getOrThrow().getData()
            }
            var b = ByteArrayStream()
            b.write(this.cachedContent.getOrThrow())
            return b
        }
    }

    /**
     * get the contentType
     *
     * @return String - The contentType
     */
    public override func getContentType(): String {
        return this.contentType
    }

    /**
     * get the charSet
     *
     * @return String - The charSet
     */
    public func getCharSet(): String {
        var parse: ParameterParser = ParameterParser()
        parse.setLowerCaseNames(true)
        let params: Map<String, Option<String>> = parse.parse(this.getContentType(), ';')
        return params.get("charset").getOrThrow().getOrThrow()
    }

    /**
     * get the Name
     *
     * @return String - The Name
     */
    public override func getName(): String {
        return Streams.checkFileName(this.fileName).getOrThrow()
    }

    /**
     * is InMemory or not
     *
     * @return Bool - is InMemory or not
     */
    public override func isInMemory(): Bool {
        if (let Some(_) = cachedContent) {
            return true
        }
        return this.dfos.getOrThrow().isInMemory()
    }

    /**
     * get the size
     *
     * @return Int64 - the size
     */
    public override func getSize(): Int64 {
        if (this.size >= 0) {
            return this.size
        }

        let InMemory = match (cachedContent) {
            case Some(_) => this.cachedContent.getOrThrow().size
            case None => 0
        }

        if (InMemory != 0) {
            return InMemory
        }

        if (this.dfos.getOrThrow().isInMemory()) {
            return this.dfos.getOrThrow().getData().getOrThrow().size
        }

        let optFile = this.dfos.getOrThrow().getFile()
        if (let Some(i) = optFile) {
            return i.info.length
        } else {
            return 0
        }
    }

    /**
     * get the value
     *
     * @return Option<Array<UInt8>> - the value
     */
    public override func get(): Option<Array<UInt8>> {
        if (this.isInMemory()) {
            let isCachedContent = match (cachedContent) {
                case Some(_) => true
                case None => false
            }

            let isDfos = match (dfos) {
                case Some(_) => true
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
            this.dfos.getOrThrow().getFile().getOrThrow().seek(SeekPosition.Begin(0))
            this.dfos.getOrThrow().getFile().getOrThrow().read(fileData.getOrThrow())
        } catch (ie: Exception) {
            return Option<Array<UInt8>>.None
        }
        return fileData
    }

    /**
     * get the value name
     *
     * @return String - the value name
     */
    public override func getString(): String {
        let s = get().getOrThrow()
        return String.fromUtf8(s)
    }

    /**
     * write the file
     *
     * @param file - File The File
     */
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
                case Some(_) => true
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

    /**
     * delete the file
     */
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

    /**
     * get Field Name
     *
     * @return - String The FieldName
     */
    public override func getFieldName(): String {
        return fieldName
    }

    /**
     * set Field Name
     *
     * @param fieldName - String The FieldName
     */
    public override func setFieldName(fieldName: String) {
        this.fieldName = fieldName
    }

    /**
     * is memory or not
     *
     * @return - Bool is memory or not
     */
    public func isGetFormField(): Bool {
        return this.isFormField
    }

    /**
     * set memory or not
     *
     * @param state - Bool The state
     */
    public override func setFormField(state: Bool) {
        isFormField = state
    }

    /**
     * get the OutputStream
     *
     * @return OutputStream - The OutputStream
     */
    public override func getOutputStream(): OutputStream {
        let isDfos = match (dfos) {
            case Some(_) => true
            case None => false
        }
        if (!isDfos) {
            dfos = DeferredFileOutputStream(sizeThreshold, tempFile, repository)
        }

        return dfos.getOrThrow()
    }

    /**
     * get Store Location
     *
     * @return Option<File> - The file
     */
    public func getStoreLocation(): Option<File> {
        let isDfos = match (dfos) {
            case Some(_) => true
            case None => false
        }

        if (!isDfos) {
            return Option<File>.None
        }

        let fileName: Option<File> = dfos.getOrThrow().getFile()
        return fileName
    }

    /**
     * toString
     *
     * @return String - toString
     */
    public func toString(): String {
        if (let Some(_) = getStoreLocation()) {
            return "name=" + getName() + " StoreLocation=" + getStoreLocation().getOrThrow().info.path.toString() + " size="+
                getSize().toString() + " bytes isFormField=" + isGetFormField().toString() + " FieldName=" +
                getFieldName()
        } else {
            return "name=" + getName() + " size=" + getSize().toString() + " bytes isFormField=" +
                isGetFormField().toString() + " FieldName=" + getFieldName()
        }
    }

    /**
     * get Headers
     *
     * @return FileItemHeaders - Headers
     */
    public override func getHeaders(): FileItemHeaders {
        return headers
    }

    /**
     * set Headers
     *
     * @param pHeaders - FileItemHeaders The File ItemHeaders
     */
    public override func setHeaders(pHeaders: FileItemHeaders) {
        this.headers = pHeaders
    }

    /**
     * get Default Charset
     *
     * @return String - Default Charset
     */
    public func getDefaultCharset(): String {
        return defaultCharset
    }

    /**
     * set Default Charset
     *
     * @param charset - String The Default Charset
     */
    public func setDefaultCharset(charset: String): Unit {
        defaultCharset = charset
    }
}

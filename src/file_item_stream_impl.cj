/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package cangjie_tpc::upload4cj

/**
 * FileItemStreamImpl
 */
public class FileItemStreamImpl <: FileItemStream {
    private let contentType: Option<String>

    let name: Option<String>

    private let fieldName: Option<String>

    private let formField: Bool

    private let stream: InterInputStream

    private var opened: Bool = false

    private var headers: Option<FileItemHeaders> = Option<FileItemHeaders>.None

    private let mfileuploadBase: Option<FileUploadBase>

    private let mFileItemIteratorImpl: FileItemIteratorImpl

    init(
        pName: Option<String>,
        pFieldName: Option<String>,
        pContentType: Option<String>,
        pFormField: Bool,
        pContentLength: Int64,
        fileupLoadBase: Option<FileUploadBase>,
        fileItemIteratorImpl: FileItemIteratorImpl
    ) {
        this.mfileuploadBase = fileupLoadBase
        this.mFileItemIteratorImpl = fileItemIteratorImpl
        this.name = pName
        this.fieldName = pFieldName
        this.contentType = pContentType
        this.formField = pFormField
        if (mfileuploadBase.getOrThrow().fileSizeMax != -1) {
            if (pContentLength != -1 && pContentLength > mfileuploadBase.getOrThrow().fileSizeMax) {
                throw FileSizeLimitExceededException(
                    "The field " + fieldName.getOrThrow() + " exceeds its maximum permitted size of " +
                        mfileuploadBase.getOrThrow().fileSizeMax.toString() + " bytes. actual" +
                        pContentLength.toString() + " filename " + pName.getOrThrow() + " field name " +
                        pFieldName.getOrThrow()
                )
            }
        }

        let itemStream: ItemInputStream = mFileItemIteratorImpl.multi.getOrThrow().newInputStream()
        var istream: InterInputStream = itemStream
        if (mfileuploadBase.getOrThrow().fileSizeMax != -1) {
            istream = LimitedInputStreamImpl(istream, mfileuploadBase.getOrThrow().fileSizeMax, itemStream)
        }
        stream = istream
    }

    /**
     * get the contentType
     *
     * @return String - The contentType
     */
    public override func getContentType(): String {
        if (let Some(i) <- contentType) {
            return i
        } else {
            return ""
        }
    }

    /**
     * get the FieldName
     *
     * @return String - The FieldName
     */
    public override func getFieldName(): String {
        return fieldName.getOrThrow()
    }

    /**
     * get the name
     *
     * @return Option<String> - The name
     */
    public override func getName(): Option<String> {
        return Streams.checkFileName(name)
    }

    /**
     * is memory or not
     *
     * @return Bool - is memory or not
     */
    public override func isFormField(): Bool {
        return formField
    }

    /**
     * get the InputStream
     *
     * @return InputStream - the InputStream
     */
    public override func openStream(): InputStream {
        if (opened) {
            throw IllegalStateException("The stream was already opened.")
        }
        return stream
    }

    func close(): Unit {
        stream.close()
    }

    /**
     * get the FileItemHeaders
     *
     * @return FileItemHeaders - The FileItemHeaders
     */
    public override func getHeaders(): FileItemHeaders {
        return headers.getOrThrow()
    }

    /**
     * set the FileItemHeaders
     *
     * @param pHeaders - FileItemHeaders The threshold
     */
    public override func setHeaders(pHeaders: FileItemHeaders): Unit {
        this.headers = pHeaders
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package upload4cj

/**
 * FileUploadBase
 */
public abstract class FileUploadBase {
    /**
     * HTTP content type header name.
     */
    public static let CONTENT_TYPE: String = "Content-type"

    /**
     * HTTP content disposition header name.
     */
    public static let CONTENT_DISPOSITION: String = "Content-disposition"

    /**
     * HTTP content type header name.
     */
    public static let CONTENT_LENGTH: String = "Content-Length"

    /**
     * HTTP CharacterEncoding.
     */
    public static let CHARACTER_ENCODING: String = "UTF-8"

    /**
     * Content-disposition value for form data.
     */
    public static let FORM_DATA: String = "form-data"

    /**
     * Content-disposition value for file attachment.
     */
    public static let ATTACHMENT: String = "attachment"

    /**
     * Part of HTTP content type header.
     */
    public static let MULTIPART: String = "multipart/"

    /**
     * HTTP content type header for multipart forms.
     */
    public static let MULTIPART_FORM_DATA: String = "multipart/form-data"

    private var fileCountMax: Int64 = -1

    var fileSizeMax: Int64 = -1

    /**
     * The maximum size permitted for the complete request, as opposed to
     * {@link #fileSizeMax}. A value of -1 indicates no maximum.
     */
    public var sizeMax: Int64 = -1

    private var headerEncoding: Option<String> = Option<String>.None

    private var listener: Option<ProgressListener> = Option<ProgressListener>.None

    /**
     * get FileItemFactory
     *
     * @return Option<FileItemFactory> - the FileItemFactory
     */
    public func getFileItemFactory(): Option<FileItemFactory>

    /**
     * set FileItemFactory
     *
     * @param factory - Option<FileItemFactory> the FileItemFactory
     */
    public func setFileItemFactory(factory: Option<FileItemFactory>): Unit

    /**
     * set File SizeMax
     *
     * @param parafileSizeMax - Int64 the max size
     */
    public func setFileSizeMax(parafileSizeMax: Int64): Unit {
        this.fileSizeMax = parafileSizeMax
    }

    /**
     * get the max size
     *
     * @return Int64 - the max size
     */
    public func getFileSizeMax(): Int64 {
        return fileSizeMax
    }

    /**
     * set size max
     *
     * @param sizeMax - Int64 the max size
     */
    public func setSizeMax(sizeMax: Int64) {
        this.sizeMax = sizeMax
    }

    /**
     * get size max
     *
     * @return Int64 - The size max
     */
    public func getSizeMax(): Int64 {
        return sizeMax
    }

    /**
     * is Multipart or not
     *
     * @param ctx - RequestContext The RequestContext
     * @return Bool - is Multipart or not
     */
    public static func isMultipartContent(ctx: RequestContext): Bool {
        let contentType: Option<String> = ctx.getContentType()
        if (let Some(i) <- contentType) {
            let lowerStr: String = i.toAsciiLower()
            if (lowerStr.startsWith(MULTIPART)) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    /**
     * parse request
     *
     * @param ctx - RequestContext The RequestContext
     * @return Option<ArrayList<FileItem>> - the FileItem ArrayList
     */
    public func parseRequest(ctx: RequestContext): Option<ArrayList<FileItem>> {
        let items: ArrayList<FileItem> = ArrayList<FileItem>()
        var successful: Bool = false
        try {
            let iter: FileItemIterator = getItemIterator(ctx)
            let fac: Option<FileItemFactory> = getFileItemFactory()
            let buffer: Array<UInt8> = Array<UInt8>(Streams.DEFAULT_BUFFER_SIZE, repeat: 0)
            if (let Some(_) <- fac) {}
            else {
                throw NullPointerException("No FileItemFactory has been set.")
            }
            while (iter.hasNext()) {
                if (items.size == fileCountMax) {
                    throw FileCountLimitExceededException(ATTACHMENT, getFileCountMax())
                }
                let item: FileItemStream = iter.next()
                let asItem = item as FileItemStreamImpl
                var fileName: Option<String> = Option<String>.None
                if (let Some(j) <- asItem) {
                    fileName = j.name
                    if (let Some(k) <- fileName) {
                        fileName = k
                    } else {
                        fileName = ""
                    }
                }
                let fileItem: FileItem = fac.getOrThrow().createItem(item.getFieldName(), item.getContentType(),
                    item.isFormField(), fileName.getOrThrow())
                items.append(fileItem)
                try {
                    Streams.copy(item.openStream(), fileItem.getOutputStream(), true, buffer)
                    let outputStream = fileItem.getOutputStream()
                    let deferr = outputStream as DeferredFileOutputStream
                    if (let Some(m) <- deferr) {
                        m.close()
                    }
                } catch (e: FileUploadException) {
                    throw FileUploadException("ParseRequest Fail")
                } catch (e: ReadWriteException) {
                    throw ReadWriteException("Processing of " + MULTIPART_FORM_DATA + " request failed.")
                }
                let fih: FileItemHeaders = item.getHeaders()
                fileItem.setHeaders(fih)
            }
            successful = true
            return items
        } catch (e: FileUploadException) {
            throw FileUploadException("ParseRequest Fail!")
        } catch (e: ReadWriteException) {
            throw ReadWriteException("read write exception")
        } finally {
            doFinally(successful, items)
        }
    }

    private func doFinally(successful: Bool, items: ArrayList<FileItem>) {
        if (!successful) {
            for (fileItem in items) {
                try {
                    fileItem.delete()
                } catch (e: Exception) {}
            }
        }
    }

    /**
     * get Item Iterator
     *
     * @param ctx - RequestContext The RequestContext
     * @return FileItemIterator - the FileItemIterator
     */
    public func getItemIterator(ctx: RequestContext): FileItemIterator {
        try {
            return FileItemIteratorImpl(ctx, this)
        } catch (e: FileUploadException) {
            throw FileUploadException("FileItem Get Fail")
        }
    }

    /**
     * parse ParameterMap
     *
     * @param ctx - RequestContext The RequestContext
     * @return Map<String, ArrayList<FileItem>> - the FileItem map
     */
    public func parseParameterMap(ctx: RequestContext): Map<String, ArrayList<FileItem>> {
        let items: ArrayList<FileItem> = parseRequest(ctx).getOrThrow()
        let itemsMap: Map<String, ArrayList<FileItem>> = HashMap<String, ArrayList<FileItem>>()
        for (fileItem in items) {
            let fieldName: String = fileItem.getFieldName()
            var mappedItems: Option<ArrayList<FileItem>> = itemsMap.get(fieldName)
            if (let Some(i) <- mappedItems) {
                i.append(fileItem)
            } else {
                mappedItems = ArrayList<FileItem>()
                itemsMap.put(fieldName, mappedItems.getOrThrow())
                mappedItems.getOrThrow().append(fileItem)
            }
        }
        return itemsMap
    }

    protected func getFieldName(headers: FileItemHeaders): Option<String> {
        return getFieldName(headers.getHeader(CONTENT_DISPOSITION))
    }

    private func getFieldName(pContentDisposition: Option<String>): Option<String> {
        var fieldName: Option<String> = Option<String>.None
        if (let Some(i) <- pContentDisposition) {
            let cdl: String = i.toAsciiLower()
            if (cdl.startsWith(FORM_DATA)) {
                let parser: ParameterParser = ParameterParser()
                parser.setLowerCaseNames(true)
                let params: Map<String, Option<String>> = parser.parse(i, r';')
                fieldName = params.get("name").getOrThrow()
                if (let Some(j) <- fieldName) {
                    fieldName = j.trimAscii()
                }
            }
        }
        return fieldName
    }

    protected func getFileName(headers: FileItemHeaders): Option<String> {
        return getFileName(headers.getHeader(CONTENT_DISPOSITION))
    }

    private func getFileName(pContentDisposition: Option<String>): Option<String> {
        var fileName: Option<String> = Option<String>.None
        if (let Some(i) <- pContentDisposition) {
            let cdl: String = i.toAsciiLower()
            if (cdl.startsWith(FORM_DATA) || cdl.startsWith(ATTACHMENT)) {
                let parser: ParameterParser = ParameterParser()
                parser.setLowerCaseNames(true)
                let params: Map<String, Option<String>> = parser.parse(i, r';')
                if (params.contains("filename")) {
                    fileName = params.get("filename").getOrThrow()
                    if (let Some(j) <- fileName) {
                        fileName = j.trimAscii()
                    } else {
                        fileName = ""
                    }
                }
            }
        }
        return fileName
    }

    protected func getParsedHeaders(headerPart: String): FileItemHeaders {
        let headerPartRunes = headerPart.toRuneArray()
        let len: Int64 = headerPartRunes.size
        let headers: FileItemHeadersImpl = newFileItemHeaders()
        var start: Int64 = 0
        while (true) {
            var end = parseEndOfLine(headerPartRunes, start)
            if (start == end) {
                break
            }
            let header: StringBuilder = StringBuilder(headerPartRunes.slice(start, end - start))
            start = end + 2
            while (start < len) {
                var nonWs = start
                while (nonWs < len) {
                    let c: Rune = headerPartRunes[nonWs]
                    if (c != r' ' && c != r'\t') {
                        break
                    }
                    nonWs++
                }
                if (nonWs == start) {
                    break
                }

                // Continuation line found
                end = parseEndOfLine(headerPartRunes, nonWs)
                header.append(" ")
                header.append(headerPartRunes.slice(nonWs, end - nonWs))
                start = end + 2
            }
            parseHeaderLine(headers, header.toString().toRuneArray())
        }
        return headers
    }

    private func parseEndOfLine(headerPartRunes: Array<Rune>, end: Int64): Int64 {
        var index: Int64 = end
        while (true) {

            let offset: Option<Int64> = headerPartRunes.indexOfRune(r'\r', index)
            if (let Some(i) <- offset) {
                if (i + 1 >= headerPartRunes.size) {
                    throw IllegalStateException("Expected headers to be terminated by an empty line.")
                }
                if (headerPartRunes[i + 1] == r'\n') {
                    return i
                }
                index = i + 1
            } else {
                throw IllegalStateException("Expected headers to be terminated by an empty line.")
            }
        }
        return 0
    }

    private func parseHeaderLine(headers: FileItemHeadersImpl, headerArray: Array<Rune>): Unit {
        let colonOffset: Option<Int64> = headerArray.indexOfRune(r':', 0)
        if (let Some(i) <- colonOffset) {
            var headerName: String = String(headerArray.slice(0, i)).trimAscii()
            let headerValue: String = String(headerArray.slice(i + 1, headerArray.size - i - 1)).trimAscii()
            headers.addHeader(headerName, headerValue)
        } else {
            return
        }
    }

    protected func newFileItemHeaders(): FileItemHeadersImpl {
        return FileItemHeadersImpl()
    }

    /**
     * get File CountMax
     *
     * @return Int64 - The File CountMax
     */
    public func getFileCountMax(): Int64 {
        return fileCountMax
    }

    /**
     * set File CountMax
     *
     * @param tempFileCountMax - Int64 The File CountMax
     */
    public func setFileCountMax(tempFileCountMax: Int64): Unit {
        this.fileCountMax = tempFileCountMax
    }

    /**
     * get Header Encoding
     *
     * @return Option<String> - The Header Encoding
     */
    public func getHeaderEncoding(): Option<String> {
        return headerEncoding
    }

    /**
     * set header encoding
     *
     * @param encoding - Option<String> The Header Encoding
     */
    public func setHeaderEncoding(encoding: Option<String>): Unit {
        this.headerEncoding = encoding
    }

    /**
     * get the Progress Listener
     *
     * @return Option<ProgressListener> - The Progress Listener
     */
    public func getProgressListener(): Option<ProgressListener> {
        return this.listener
    }

    /**
     * set progress listener
     *
     * @param pListener - Option<ProgressListener> The Progress Listener
     */
    public func setProgressListener(pListener: Option<ProgressListener>): Unit {
        this.listener = pListener
    }
}

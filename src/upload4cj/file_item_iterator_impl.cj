/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

/**
 * FileItemIteratorImpl
 */
public class FileItemIteratorImpl <: FileItemIterator {
    /**
     * HTTP content type header for multipart forms.
     */
    public static let MULTIPART_FORM_DATA: String = "multipart/form-data"

    /**
     * HTTP content type header for multiple uploads.
     */
    public static let MULTIPART_MIXED: String = "multipart/mixed"

    /**
     * Part of HTTP content type header.
     */
    public static let MULTIPART: String = "multipart/"

    /**
     * HTTP content length header name.
     */
    public static let CONTENT_LENGTH: String = "Content-Length"

    private var headerEncoding: Option<String> = Option<String>.None

    private var boundary: Option<Array<UInt8>> = Option<Array<UInt8>>.None

    private var notifier: Option<ProgressNotifier> = Option<ProgressNotifier>.None

    private var listener: Option<ProgressListener> = Option<ProgressListener>.None

    /**
     * HTTP content type header name.
     */
    public static let CONTENT_TYPE: String = "Content-type"

    var multi: Option<MultipartStream> = Option<MultipartStream>.None

    private var currentFieldName: Option<String> = Option<String>.None

    private var skipPreamble: Bool = false

    private var itemValid: Bool = false

    private var eof: Bool = false

    private var currentItem: Option<FileItemStreamImpl> = Option<FileItemStreamImpl>.None

    private let mfileuploadBase: Option<FileUploadBase>

    init(ctx: Option<RequestContext>, fileupLoadBase: FileUploadBase) {
        this.mfileuploadBase = fileupLoadBase
        if (let Some(i) = ctx) {
            let contentType: Option<String> = i.getContentType()
            if (let Some(j) = contentType) {
                if (!j.toAsciiLower().startsWith(MULTIPART)) {
                    throw InvalidContentTypeException("the request doesn't contain a " + MULTIPART_FORM_DATA + " or " + MULTIPART_MIXED +" stream, content type header is " + j)
                } else {
                    //正常逻辑
                    let contentLengthInt: Int64 = i.contentLength()
                    //这个先遗留
                    let requestSize: Int64 = contentLengthInt
                    var input: Option<InputStream> = Option<InputStream>.None
                    if (this.mfileuploadBase.getOrThrow().sizeMax >= 0) {
                        //表示request内容长度有限制
                        if (requestSize != -1 && requestSize > this.mfileuploadBase.getOrThrow().sizeMax) {
                            throw SizeLimitExceededException("the request was rejected because its size (" + requestSize.toString() +") exceeds the configured maximum (" +this.mfileuploadBase.getOrThrow().sizeMax.toString() + ")")
                        }
                        // N.B. this is eventually closed in MultipartStream processing
                        input = LimitedInputStreamImpl(ctx.getOrThrow().getInputStream(),this.mfileuploadBase.getOrThrow().sizeMax,Option<ItemInputStream>.None)
                    } else {
                        input = i.getInputStream()
                    }
                    var charEncoding: Option<String> = headerEncoding
                    if (let Some(_) = charEncoding) {}
                    else {
                        charEncoding = i.getCharacterEncoding()
                    }
                    boundary = getBoundary(j)
                    if (let Some(_) = boundary) {
                        notifier = ProgressNotifier(mfileuploadBase.getOrThrow().getProgressListener(), requestSize)
                        try {
                            multi = MultipartStream(input.getOrThrow(), boundary, notifier.getOrThrow())
                        } catch (iae: IllegalArgumentException) {
                            throw InvalidContentTypeException("The boundary specified in the " + CONTENT_TYPE + " header is too long" + iae.toString())
                        }
                        multi.getOrThrow().setHeaderEncoding(charEncoding)
                        skipPreamble = true
                        findNextItem()
                    } else {
                        throw FileUploadException("the request was rejected because no multipart boundary was found")
                    }
                }
            } else {
                throw InvalidContentTypeException("the request doesn't contain a " + MULTIPART_FORM_DATA + " or " + MULTIPART_MIXED +" stream, content type header is null")
            }
        } else {
            throw NullPointerException("ctx parameter")
        }
    }


    private func calcNextPart():Bool{
        var nextPartTemp: Bool
        if (skipPreamble) {
            nextPartTemp = multi.getOrThrow().skipPreamble()
        } else {
            nextPartTemp = multi.getOrThrow().readBoundary()
        }
        return nextPartTemp
    }

    private func doResetCurrentItem(){
         if (let Some(_) = currentItem) {
            currentItem.getOrThrow().close()
            currentItem = Option<FileItemStreamImpl>.None
        }
    }


    private func findNextItem(): Bool {
        if (eof) {
            return false
        }
        doResetCurrentItem()
        while (true) {
            var nextPart: Bool = calcNextPart()
            if (!nextPart) {
                if (let Some(_) = currentFieldName) {}
                else {
                    eof = true
                    return false
                }
                multi.getOrThrow().setBoundary(boundary.getOrThrow())
                currentFieldName = Option<String>.None
                continue
            }
            let headers: FileItemHeaders = mfileuploadBase.getOrThrow().getParsedHeaders(multi.getOrThrow().readHeaders())
            if (let Some(j) = currentFieldName) {
                let fileName: Option<String> = mfileuploadBase.getOrThrow().getFileName(headers)
                if (let Some(n) = fileName) {
                    currentItem = FileItemStreamImpl(n,j,headers.getHeader(CONTENT_TYPE),false,getContentLength(headers),mfileuploadBase,this)
                    currentItem.getOrThrow().setHeaders(headers)
                    notifier.getOrThrow().noteItem()
                    itemValid = true
                    return true
                }
            } else {
                let fieldName: Option<String> = mfileuploadBase.getOrThrow().getFieldName(headers)
                if (let Some(k) = fieldName) {
                    let subContentType: Option<String> = headers.getHeader(CONTENT_TYPE)
                    if (let Some(l) = subContentType) {
                        let nameLower: String = l.toAsciiLower()
                        if (nameLower.startsWith(MULTIPART_MIXED)) {
                            currentFieldName = fieldName
                            // Multiple files associated with this field name
                            let subBoundary: Array<UInt8> = getBoundary(l).getOrThrow()
                            multi.getOrThrow().setBoundary(subBoundary)
                            skipPreamble = true
                            continue
                        }
                    }
                    doLogic(headers,k)
                    return true
                }
            }
            multi.getOrThrow().discardBodyData()
        }
        return false
    }


    private func doLogic(headersTemp: FileItemHeaders,fieldNameTmep:String){
        let fileName: Option<String> = mfileuploadBase.getOrThrow().getFileName(headersTemp)
        var isfileNameNull: Bool = false
        if (let Some(_) = fileName) {
            isfileNameNull = false
        } else {
            isfileNameNull = true
        }
        currentItem = FileItemStreamImpl(fileName,fieldNameTmep,headersTemp.getHeader(CONTENT_TYPE),isfileNameNull,getContentLength(headersTemp),mfileuploadBase,this)
        currentItem.getOrThrow().setHeaders(headersTemp)
        notifier.getOrThrow().noteItem()
        itemValid = true
    }




    protected func getBoundary(contentType: String): Option<Array<UInt8>> {
        let parser: ParameterParser = ParameterParser()
        parser.setLowerCaseNames(true)
        let charArray = Array<Char>([';', ','])
        let params: Map<String, Option<String>> = parser.parse(contentType, charArray)
        let boundaryStr: Option<Option<String>> = params.get("boundary")
        if (let Some(k) = boundaryStr) {
            if (let Some(_) = k) {
                var boundary: Array<UInt8>
                try {
                    //仓颉目前只支持utf-8
                    boundary = k.getOrThrow().toUtf8Array()
                } catch (e: UnsupportedEncodingException) {
                    throw UnsupportedEncodingException("encoding exception")
                }
                return boundary
            } else {
                return Option<Array<UInt8>>.None
            }
        } else {
            return Option<Array<UInt8>>.None
        }
    }

    private func getContentLength(pHeaders: FileItemHeaders): Int64 {
        try {
            let contentLength: String = pHeaders.getHeader(CONTENT_LENGTH).getOrThrow()
            let len: Int64 = Int64.parse(contentLength)
            return len
        } catch (e: Exception) {
            return -1
        }
    }

    /**
     * iterator have next value or not
     *
     * @return Bool - have or not
     */
    public override func hasNext(): Bool {
        if (eof) {
            return false
        }

        if (itemValid) {
            return true
        }

        try {
            return findNextItem()
        } catch (e: FileUploadException) {
            throw FileUploadException("FindNextItem Fail")
        }
    }

    /**
     * get iterator next value
     *
     * @return FileItemStream - get the FileItemStream
     */
    public override func next(): FileItemStream {
        let hsNext: Bool = hasNext()
        if (eof || (!itemValid && !hsNext)) {
            throw NoSuchElementException("No Such Element")
        }
        itemValid = false
        return currentItem.getOrThrow()
    }
}

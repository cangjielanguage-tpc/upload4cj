package upload4cj

public class FileItemIteratorImpl <: FileItemIterator {


    /**
     * HTTP content type header for multipart forms.
     */
    public static let MULTIPART_FORM_DATA:String = "multipart/form-data"

    /**
     * HTTP content type header for multiple uploads.
     */
    public static let MULTIPART_MIXED:String = "multipart/mixed"

    /**
     * Part of HTTP content type header.
     */
    public static let MULTIPART:String = "multipart/"

    /**
     * HTTP content length header name.
     */
    public static let CONTENT_LENGTH:String = "Content-length"


     /**
     * The maximum size permitted for the complete request, as opposed to
     * {@link #fileSizeMax}. A value of -1 indicates no maximum.
     */
    private var sizeMax:Int64 = -1


    /**
     * The content encoding to use when reading part headers.
     */
    private var headerEncoding:Option<String> = Option<String>.None


    /**
    * The boundary, which separates the various parts.
    */
    private var boundary:Option<Array<UInt8>> = Option<Array<UInt8>>.None


    /**
    * The notifier, which used for triggering the
    * {@link ProgressListener}.
    */
    private var  notifier:Option<ProgressNotifier> = Option<ProgressNotifier>.None

     /**
     * The progress listener.
     */
    private var listener:Option<ProgressListener> = Option<ProgressListener>.None


     /**
     * HTTP content type header name.
     */
    public static let CONTENT_TYPE:String = "Content-type"


    /**
        * The multi part stream to process.
        */
    var multi:Option<MultipartStream> = Option<MultipartStream>.None


    /**
        * The current items field name.
        */
    private var currentFieldName:Option<String> = Option<String>.None


    /**
    * Whether we are currently skipping the preamble.
    */
    private var skipPreamble:Bool = false

     /**
    * Whether the current item may still be read.
    */
    private var itemValid:Bool = false

    /**
    * Whether we have seen the end of the file.
    */
    private var eof:Bool = false


    /**
    * The item, which we currently process.
    */
    private var currentItem:Option<FileItemStreamImpl> = Option<FileItemStreamImpl>.None

    private let mfileuploadBase:Option<FileUploadBase>

    init (ctx: Option<RequestContext>,fileupLoadBase:FileUploadBase) {
        this.mfileuploadBase = fileupLoadBase
        if(let Some(i) = ctx){
            let contentType:Option<String> = i.getContentType()
            if(let Some(j) = contentType){
                if(!j.toAsciiLower().startsWith(MULTIPART)){
                    throw InvalidContentTypeException("the request doesn't contain a "+ MULTIPART_FORM_DATA +" or "+ MULTIPART_MIXED +" stream, content type header is "+j)
                }else{
                    //正常逻辑
                    let contentLengthInt:Int64 = i.getContentLength()
                    //这个先遗留
                    let requestSize:Int64 = contentLengthInt
                    var input:Option<InputStream>  = Option<InputStream>.None
                    if (sizeMax >= 0) {
                        //表示request内容长度有限制
                            if (requestSize != -1 && requestSize > sizeMax) {
                                throw SizeLimitExceededException("the request was rejected because its size ("+requestSize.toString()+") exceeds the configured maximum ("+sizeMax.toString()+")")
                            }
                            // N.B. this is eventually closed in MultipartStream processing
                            input = LimitedInputStreamImpl(ctx.getOrThrow().getInputStream(), sizeMax)
                    } else {
                        input = i.getInputStream()
                    }
                    var charEncoding:Option<String> = headerEncoding
                    if(let Some(k) = charEncoding){
                    }else{
                        charEncoding = i.getCharacterEncoding()
                    }
                    boundary = getBoundary(j)
                    if(let Some(l) = boundary){
                        notifier = ProgressNotifier(listener, requestSize)
                        try{
                            multi = MultipartStream(input.getOrThrow(), boundary, notifier.getOrThrow())
                        }catch(iae:IllegalArgumentException){
                            throw InvalidContentTypeException("The boundary specified in the "+CONTENT_TYPE+" header is too long"+iae.toString())
                        }
                        multi.getOrThrow().setHeaderEncoding(charEncoding)
                        skipPreamble = true
                        findNextItem()
                    }else{
                        throw FileUploadException("the request was rejected because no multipart boundary was found")
                    }
                }
            }else{
                throw InvalidContentTypeException("the request doesn't contain a "+ MULTIPART_FORM_DATA +" or "+ MULTIPART_MIXED +" stream, content type header is "+j)
            }
        }else{
            throw NullPointerException("ctx parameter")
        }
    }

    private func findNextItem():Bool{
        if (eof) {
            return false
        }
        if(let Some(i) = currentItem){
            currentItem = Option<FileItemStreamImpl>.None
        }
        while(true){
            var nextPart:Bool
            if (skipPreamble) {
                nextPart = multi.getOrThrow().skipPreamble()
            } else {
                nextPart = multi.getOrThrow().readBoundary()
            }
            if(!nextPart){
                if(let Some(i) = currentFieldName){
                }else{
                     eof = true
                    return false
                }
                multi.getOrThrow().setBoundary(boundary.getOrThrow())
                currentFieldName = Option<String>.None
                continue
            }
            let headers:FileItemHeaders = mfileuploadBase.getOrThrow().getParsedHeaders(multi.getOrThrow().readHeaders())
            if(let Some(j) = currentFieldName){
                let fileName:Option<String> = mfileuploadBase.getOrThrow().getFileName(headers)
                if(let Some(n) = fileName){
                    currentItem = FileItemStreamImpl(n,j,headers.getHeader(CONTENT_TYPE),false,getContentLength(headers),mfileuploadBase,this)
                    currentItem.getOrThrow().setHeaders(headers)
                    notifier.getOrThrow().noteItem()
                    itemValid = true
                    return true
                }
            }else{
                let fieldName:Option<String> = mfileuploadBase.getOrThrow().getFieldName(headers)
                if(let Some(k) = fieldName){
                    let subContentType:Option<String> = headers.getHeader(CONTENT_TYPE)
                    if(let Some(l) = subContentType){
                        let nameLower:String =  l.toAsciiLower()
                        if(nameLower.startsWith(MULTIPART_MIXED)){
                            currentFieldName = fieldName
                            // Multiple files associated with this field name
                            let subBoundary:Array<UInt8> = getBoundary(l).getOrThrow()
                            multi.getOrThrow().setBoundary(subBoundary)
                            skipPreamble = true
                            continue
                        }
                    }
                    let fileName:Option<String> = mfileuploadBase.getOrThrow().getFileName(headers)
                    var isfileNameNull:Bool = false
                    if(let Some(m) = fileName){
                        isfileNameNull = false
                    }else{
                        isfileNameNull = true
                    }
                    currentItem = FileItemStreamImpl(fileName,k,headers.getHeader(CONTENT_TYPE),isfileNameNull,getContentLength(headers),mfileuploadBase,this)
                    currentItem.getOrThrow().setHeaders(headers)
                    notifier.getOrThrow().noteItem()
                    itemValid = true
                    return true
                }
            }
            multi.getOrThrow().discardBodyData()
        }
        return false
    }

    protected func getBoundary(contentType:String):Option<Array<UInt8>>{
        let parser:ParameterParser = ParameterParser()
        parser.setLowerCaseNames(true)
        let charArray = Array<Char>([';',','])
        let params:Map<String,Option<String>> = parser.parse(contentType,charArray)
        let boundaryStr:Option<String> = params.get("boundary").getOrThrow()
        if(let Some(i) = boundaryStr){
            var boundary:Array<UInt8>
            try{
                //仓颉目前只支持utf-8
                boundary = boundaryStr.getOrThrow().toUtf8Array()
            }catch(e:UnsupportedEncodingException){
                throw UnsupportedEncodingException("encoding exception")
            }
            return boundary
        }else{
            return Option<Array<UInt8>>.None
        }
    }

    private func getContentLength(pHeaders:FileItemHeaders):Int64{
        try{
            let contentLength:String = pHeaders.getHeader(CONTENT_LENGTH).getOrThrow()
            let len:Int64 = Int64.parse(contentLength)
            return len
        }catch(e:Exception){
            return -1
        }
    }

    public override func hasNext (): Bool {
        if(eof){
            return false
        }

        if(itemValid) {
            return true
        }

        try{
            return findNextItem()
        } catch (e:FileUploadIOException) {
            // unwrap encapsulated SizeException
            throw e.getCause()
        }
    }

    public override func next():FileItemStream{
        if(eof || (!itemValid && !hasNext())) {
            throw  NoSuchElementException()
        }
        itemValid = false
        return currentItem.getOrThrow()
    }

}

package upload4cj

public abstract class FileUploadBase {
    /**
     * HTTP content type header name.
     */
    public static let CONTENT_TYPE:String = "Content-type"
    /**
     * HTTP content disposition header name.
     */
    public static let CONTENT_DISPOSITION:String = "Content-disposition"
     /**
     * HTTP content type header name.
     */
    public static let CONTENT_LENGTH:String = "Content-Length"
    /**
     * Content-disposition value for form data.
     */
    public static let FORM_DATA:String = "form-data"
     /**
     * Content-disposition value for file attachment.
     */
    public static let ATTACHMENT:String = "attachment"
     /**
     * Part of HTTP content type header.
     */
    public static let MULTIPART:String = "multipart/"
    /**
     * HTTP content type header for multipart forms.
     */
    public static let MULTIPART_FORM_DATA:String = "multipart/form-data"
    /**
     * The maximum permitted number of files that may be uploaded in a single
     * request. A value of -1 indicates no maximum.
     */
    private var fileCountMax:Int64 = -1
    /**
     * The maximum size permitted for a single uploaded file, as opposed
     * to {@link #sizeMax}. A value of -1 indicates no maximum.
     */
    var fileSizeMax:Int64 = -1
    /**
     * The maximum size permitted for the complete request, as opposed to
     * {@link #fileSizeMax}. A value of -1 indicates no maximum.
     */
    public var sizeMax:Int64 = -1
     /**
     * The content encoding to use when reading part headers.
     */
    private var headerEncoding:Option<String> = Option<String>.None

    private var listener:Option<ProgressListener> = Option<ProgressListener>.None

    public func getFileItemFactory(): Option<FileItemFactory>

    public func setFileItemFactory(factory: Option<FileItemFactory>): Unit

    public func setFileSizeMax(parafileSizeMax:Int64):Unit{
        this.fileSizeMax = parafileSizeMax
    }

    public func getFileSizeMax():Int64{
        return fileSizeMax
    }

    public func setSizeMax(sizeMax:Int64){
        this.sizeMax = sizeMax
    }

    public func getSizeMax():Int64{
        return sizeMax
    }

    public static func isMultipartContent(ctx:RequestContext):Bool{
        let contentType:Option<String> = ctx.getContentType()
        if(let Some(i) = contentType){
             let lowerStr:String =  i.toAsciiLower()
             if(lowerStr.startsWith(MULTIPART)){
                return true
             }else{
                return false
             }
        }else{
            return false
        }
    }

    public func parseRequest(ctx: RequestContext): Option<ArrayList<FileItem>> {
        let items:ArrayList<FileItem> = ArrayList<FileItem>()
        var successful:Bool = false
        try{
            let iter:FileItemIterator = getItemIterator(ctx)
            let fac:Option<FileItemFactory> = getFileItemFactory()
            let buffer:Array<UInt8> = Array<UInt8>(Streams.DEFAULT_BUFFER_SIZE,item:0)
            if(let Some(i) = fac){
            }else{
                throw NullPointerException("No FileItemFactory has been set.")
            }
           while(iter.hasNext()){
                if(items.size == fileCountMax){
                    throw FileCountLimitExceededException(ATTACHMENT,getFileCountMax())
                }
                let item:FileItemStream =  iter.next()
                let asItem = item as FileItemStreamImpl
                var fileName:Option<String> = Option<String>.None
                if(let Some(j) = asItem){
                    fileName = j.name
                    if(let Some(k) = fileName){
                        fileName = k
                    }else{
                        fileName = ""
                    }
                }
                let fileItem:FileItem = fac.getOrThrow().createItem(item.getFieldName(), item.getContentType(),item.isFormField(), fileName.getOrThrow())
                items.append(fileItem)
                try{
                    Streams.copy(item.openStream(), fileItem.getOutputStream(), true, buffer)
                }catch (e:FileUploadIOException) {
                    throw e.getCause()
                } catch (e:IOException) {
                    throw  IOException("Processing of "+ MULTIPART_FORM_DATA +" request failed. "+e.message)
                }
                let fih:FileItemHeaders = item.getHeaders()
                fileItem.setHeaders(fih)
           }
            successful = true
            return items
        }catch(e:FileUploadIOException){
            throw e.getCause()
        }catch(e:IOException) {
            throw IOException(e.message)
        }finally{
            if (!successful) {
                for (fileItem in items) {
                    try {
                        fileItem.delete()
                    }catch(e:Exception){}
                }
            }
        }
    }

    public func getItemIterator(ctx: RequestContext): FileItemIterator {
        try {
            return FileItemIteratorImpl(ctx,this)
        } catch (e: FileUploadIOException) {
            throw e.getCause()
        }
    }

    public func parseParameterMap(ctx:RequestContext):Map<String,ArrayList<FileItem>>{
        let items:ArrayList<FileItem> = parseRequest(ctx).getOrThrow()
        let itemsMap:Map<String, ArrayList<FileItem>> = HashMap<String, ArrayList<FileItem>>()
        for(fileItem in items){
            let fieldName:String = fileItem.getFieldName()
            var mappedItems:Option<ArrayList<FileItem>> =  itemsMap.get(fieldName)
            if(let Some(i) = mappedItems){
                i.append(fileItem)
            }else{
                mappedItems = ArrayList<FileItem>()
                itemsMap.put(fieldName, mappedItems.getOrThrow())
                mappedItems.getOrThrow().append(fileItem)
            }
        }
         return itemsMap
    }

    protected func getFieldName(headers:FileItemHeaders):Option<String>{
        return getFieldName(headers.getHeader(CONTENT_DISPOSITION))
    }

    private func getFieldName(pContentDisposition:Option<String>):Option<String>{
        var fieldName:Option<String> = Option<String>.None
        if(let Some(i) = pContentDisposition){
             let cdl:String =  i.toAsciiLower()
             if(cdl.startsWith(FORM_DATA)){
                let parser:ParameterParser = ParameterParser()
                parser.setLowerCaseNames(true)
                let params:Map<String, Option<String>> = parser.parse(i, ';')
                fieldName = params.get("name").getOrThrow()
                if(let Some(j) = fieldName){
                    fieldName = j.trimAscii()
                }
             }
        }
        return fieldName
    }

    protected func getFileName(headers:FileItemHeaders):Option<String>{
        return getFileName(headers.getHeader(CONTENT_DISPOSITION))
    }

    private func getFileName(pContentDisposition:Option<String>):Option<String>{
        var fileName:Option<String> = Option<String>.None
        if(let Some(i) = pContentDisposition){
            let cdl:String =  i.toAsciiLower()
            if (cdl.startsWith(FORM_DATA) || cdl.startsWith(ATTACHMENT)) {
                let parser:ParameterParser = ParameterParser()
                parser.setLowerCaseNames(true)
                let params:Map<String, Option<String>> = parser.parse(i, ';')
                if(params.contains("filename")){
                    fileName = params.get("filename").getOrThrow()
                    if(let Some(j) = fileName){
                        fileName = j.trimAscii()
                    }else{
                        fileName = ""
                    }
                }
            }
        }
        return fileName
    }

    protected func getParsedHeaders(headerPart:String):FileItemHeaders{
        let len:Int64 = headerPart.size
        let headers:FileItemHeadersImpl = newFileItemHeaders()
        var start:Int64 = 0
        while(true){
            var end  = parseEndOfLine(headerPart,start)
            if(start == end){
                break
            }
            let header:StringBuilder = StringBuilder(headerPart.substring(start,end-start))
            start = end + 2
            while(start < len){
                var nonWs = start
                while(nonWs < len){
                    let c:Char = headerPart.charAt(nonWs)
                    if (c != ' '  &&  c != '\t') {
                        break
                    }
                    nonWs++
                }
                if (nonWs == start) {
                    break
                }
                // Continuation line found
                end = parseEndOfLine(headerPart, nonWs)
                header.append(" ").append(headerPart.substring(nonWs, end-nonWs))
                start = end + 2
            }
            parseHeaderLine(headers, header.toString())
        }
        return headers
    }

    private func parseEndOfLine(headerPart:String,end:Int64):Int64{
        var index:Int64 = end
        while(true){
            let offset:Option<Int64> = headerPart.indexOf('\r', index)
            if(let Some(i) = offset){
                if(i+1 >= headerPart.size){
                    throw IllegalStateException("Expected headers to be terminated by an empty line.")
                }
            }else{
                throw IllegalStateException("Expected headers to be terminated by an empty line.")
            }
            if (headerPart.charAt(offset.getOrThrow() + 1) == '\n') {
                return offset.getOrThrow()
            }
            index = offset.getOrThrow() + 1
        }
        return 0
    }

    private func parseHeaderLine(headers:FileItemHeadersImpl,header:String):Unit{
        let colonOffset:Option<Int64> = header.indexOf(':')
        if(let Some(i) = colonOffset){
            var headerName:String = header.substring(0, i).trimAscii()
            let headerValue:String = header.substring(i + 1).trimAscii()
            headers.addHeader(headerName, headerValue)
        }else{
            return
        }
    }

    protected func newFileItemHeaders():FileItemHeadersImpl{
        return FileItemHeadersImpl()
    }

    public func getFileCountMax():Int64{
        return fileCountMax
    }

    public func setFileCountMax(tempFileCountMax:Int64):Unit{
        this.fileCountMax = tempFileCountMax
    }

    public func getHeaderEncoding():Option<String>{
        return headerEncoding
    }

    public func setHeaderEncoding(encoding:Option<String>):Unit{
        this.headerEncoding = encoding
    }

    public func getProgressListener():Option<ProgressListener>{
        return this.listener
    }

    public func setProgressListener(pListener:Option<ProgressListener>):Unit{
        this.listener = pListener
    }
}

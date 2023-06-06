package upload4cj

public class FileItemStreamImpl <: FileItemStream {

    /**
    * The file items content type.
    */
    private let contentType:Option<String>
    /**
    * The file items file name.
    */
    let name:Option<String>
    /**
    * The file items field name.
    */
    private let fieldName:Option<String>
    /**
    * Whether the file item is a form field.
    */
    private let formField:Bool


    /**
    * The file items input stream.
    */
    private let stream:InputStream

    /**
    * Whether the file item was already opened.
    */
    private var opened:Bool = false

    /**
    * The headers, if any.
    */
    private var headers:Option<FileItemHeaders> = Option<FileItemHeaders>.None

    private let mfileuploadBase:Option<FileUploadBase>

    private let mFileItemIteratorImpl:FileItemIteratorImpl

    init(pName:Option<String>,pFieldName:Option<String>,pContentType:Option<String>,pFormField:Bool,pContentLength:Int64,fileupLoadBase:Option<FileUploadBase>,fileItemIteratorImpl:FileItemIteratorImpl){
        this.mfileuploadBase = fileupLoadBase
        this.mFileItemIteratorImpl = fileItemIteratorImpl
        this.name = pName
        this.fieldName = pFieldName
        this.contentType = pContentType
        this.formField = pFormField
        if(mfileuploadBase.getOrThrow().fileSizeMax != -1){
            if (pContentLength != -1 && pContentLength > mfileuploadBase.getOrThrow().fileSizeMax) {
                throw FileSizeLimitExceededException("The field "+ fieldName.getOrThrow() +" exceeds its maximum permitted size of "+ mfileuploadBase.getOrThrow().fileSizeMax.toString() +" bytes. actual"+pContentLength.toString()+" filename "+pName.getOrThrow()+" field name "+pFieldName.getOrThrow())
            }
        }
        let itemStream:ItemInputStream = mFileItemIteratorImpl.multi.getOrThrow().newInputStream()
        var istream:InputStream = itemStream
        if(mfileuploadBase.getOrThrow().fileSizeMax != -1){
            istream = LimitedInputStreamImpl(istream,mfileuploadBase.getOrThrow().fileSizeMax)
        }
          stream = istream
    }


    public override func getContentType():String{
        if(let Some(i) = contentType){
            return i
        }else{
            return ""
        }
    }

    public override func getFieldName():String{
        return fieldName.getOrThrow()
    }


    public override func getName():Option<String>{
        return Streams.checkFileName(name)
    }

    public override func isFormField():Bool{
        return formField
    }

    public override func openStream():InputStream{
        if(opened){
            throw IllegalStateException("The stream was already opened.")
        }
        return stream
    }

    public override func getHeaders():FileItemHeaders{
        return headers.getOrThrow()
    }

    public override func setHeaders(pHeaders:FileItemHeaders):Unit{
        this.headers = pHeaders
    }

}

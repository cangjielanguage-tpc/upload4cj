package upload4cj

public class DiskFileItemFactory <: FileItemFactory {

    public static let DEFAULT_SIZE_THRESHOLD:Int64 = 10240

    private var sizeThreshold:Int64 = DEFAULT_SIZE_THRESHOLD

    private var repository:Option<Directory> = Option<Directory>.None

    private var defaultCharset:String = DiskFileItem.DEFAULT_CHARSET

    public init(){
        this(DEFAULT_SIZE_THRESHOLD,Option<Directory>.None)
    }

    public init(sizeThreshold:Int64,repository:Option<Directory>){
         this.sizeThreshold = sizeThreshold
         this.repository = repository
    }

    public override func createItem(fieldName: String, contentType: String, isFormField: Bool, fileName: String) :FileItem{
        return DiskFileItem(fieldName, contentType, isFormField, fileName, sizeThreshold, repository)
    }

    public func getDefaultCharset():String{
        return defaultCharset
    }

    public func setDefaultCharset(pCharset:String):Unit{
        defaultCharset = pCharset
    }

}


package upload4cj

public open class FileUpload <: FileUploadBase {

    private var fileItemFactory = Option<FileItemFactory>.None

    public init () {
        super()
    }

    public init (fileItemFactory: Option<FileItemFactory>) {
        super()
        this.fileItemFactory = fileItemFactory
    }

    public override func getFileItemFactory(): Option<FileItemFactory>{
        return fileItemFactory
    }

    public override func setFileItemFactory(factory: Option<FileItemFactory>) {
        this.fileItemFactory = factory
    }



}

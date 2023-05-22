package upload4cj

public abstract class FileUploadBase {


    public static let CONTENT_LENGTH = "Content-length"

    public func getFileItemFactory(): Option<FileItemFactory>

    public func setFileItemFactory(factory: Option<FileItemFactory>): Unit

    public func parseRequest(ctx: RequestContext): Option<Array<FileItem>> { 
        println(55)
        var items = ArrayList<FileItem>()
        var successful: Bool = false

        return Option<Array<FileItem>>.None
    }


    public func getItemIterator(ctx: RequestContext): FileItemIterator {
        try {
            return FileItemIteratorImpl(ctx)
        } catch (e: FileUploadIOException) {
            throw e.getCause()
        }
    }

}

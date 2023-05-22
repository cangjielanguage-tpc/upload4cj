package upload4cj

public class FileItemIteratorImpl <: FileItemIterator { 

    public init (ctx: RequestContext) {
        var contentType = ctx.getContentType()
        var contentLengthInt = ctx.getContentLength()

        var input: InputStream = ctx.getInputStream()

    }

    public override func hasNext (): Bool {
        return true
    }
    
}
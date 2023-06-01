package upload4cj
from std import core.*

public class FileUploadIOException <: Exception {

    private var cause: FileUploadException

    public init(pCause: FileUploadException) {
        cause = pCause
    }

    public func getCause(): FileUploadException{
        return cause
    }

}

public class FileUploadException <: Exception {
    public init() {
        super()
    }
    public init(messages: String) {
        super(messages)
    }
}

public class IllegalBoundaryException <: Exception {
    public init() {
        super()
    }
    public init(messages: String) {
        super(messages)
    }
}

public class MalformedStreamException <: Exception {
    public init() {
        super()
    }
    public init(messages: String) {
        super(messages)
    }
}

public class ItemSkippedException <: Exception {
    public init() {
        super()
    }
    public init(messages: String) {
        super(messages)
    }
}

public class FileWriteException <: Exception {
    public init() {
        super()
    }
    public init(messages: String) {
        super(messages)
    }
}

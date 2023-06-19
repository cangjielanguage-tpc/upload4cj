package upload4cj

from std import core.*

public class FileUploadException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class IllegalBoundaryException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class MalformedStreamException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class NullPointerException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class InvalidContentTypeException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class SizeLimitExceededException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class UnsupportedEncodingException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class IllegalStateException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class NoSuchElementException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class FileCountLimitExceededException <: Exception {
    private let mLimit: Int64

    public init(messages: String, limit: Int64) {
        super(messages)
        this.mLimit = limit
    }

    public func getLimit(): Int64 {
        return mLimit
    }
}

public class FileSizeLimitExceededException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class InvalidFileNameException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class ItemSkippedException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

public class ParseException <: Exception {
    public init(messages: String) {
        super(messages)
    }
}

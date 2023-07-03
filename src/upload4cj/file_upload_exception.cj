/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

from std import core.*

/**
 * FileUploadException
 */
public class FileUploadException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class IllegalBoundaryException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class MalformedStreamException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class NullPointerException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class InvalidContentTypeException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class SizeLimitExceededException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class UnsupportedEncodingException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class IllegalStateException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class NoSuchElementException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class FileCountLimitExceededException <: Exception {
    private let mLimit: Int64

    /**
     * init
     *
     * @param messages - String the message
     * @param limit - Int64 the limit
     */
    public init(messages: String, limit: Int64) {
        super(messages)
        this.mLimit = limit
    }

    /**
     * init
     *
     * @return limit - the limit
     */
    public func getLimit(): Int64 {
        return mLimit
    }
}

/**
 * FileUploadException
 */
public class FileSizeLimitExceededException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class InvalidFileNameException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class ItemSkippedException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class ParseException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class QDecoderException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

/**
 * FileUploadException
 */
public class ReadWriteException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    public init(messages: String) {
        super(messages)
    }
}

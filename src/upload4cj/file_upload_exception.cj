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
 * IllegalBoundaryException
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
 * MalformedStreamException
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
 * NullPointerException
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
 * InvalidContentTypeException
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
 * SizeLimitExceededException
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
 * UnsupportedEncodingException
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
 * IllegalStateException
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
 * NoSuchElementException
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
 * FileCountLimitExceededException
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
 * FileSizeLimitExceededException
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
 * InvalidFileNameException
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
 * ItemSkippedException
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
 * ParseException
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
 * QDecoderException
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
 * ReadWriteException
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

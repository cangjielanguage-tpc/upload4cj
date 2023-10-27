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
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "FileUploadException: "+ mMessage
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
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "IllegalBoundaryException: "+ mMessage
    }
}

/**
 * MalformedStreamException
 */
public class MalformedStreamException <: ReadWriteException {
    /**
     * init
     *
     * @param messages - String the message
     */
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "MalformedStreamException: "+ mMessage
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
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "NullPointerException: "+ mMessage
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
      private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "InvalidContentTypeException: "+ mMessage
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
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "SizeLimitExceededException: "+ mMessage
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
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "UnsupportedEncodingException: "+ mMessage
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
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "IllegalStateException: "+ mMessage
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
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "NoSuchElementException: "+ mMessage
    }
}

/**
 * FileCountLimitExceededException
 */
public class FileCountLimitExceededException <: Exception {
    private let mLimit: Int64
    private var mMessage = ""

    /**
     * init
     *
     * @param messages - String the message
     * @param limit - Int64 the limit
     */
    public init(messages: String, limit: Int64) {
        super(messages)
        this.mLimit = limit
        this.mMessage = messages
    }

    public func toString():String{
        return "FileCountLimitExceededException: "+ mMessage
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
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "FileSizeLimitExceededException: "+ mMessage
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
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "InvalidFileNameException: "+ mMessage
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
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "ItemSkippedException: "+ mMessage
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
     private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "ParseException: "+ mMessage
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
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "QDecoderException: "+ mMessage
    }
}

/**
 * ReadWriteException
 */
public open class ReadWriteException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */

    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public open func toString():String{
        return "ReadWriteException: "+ mMessage
    }
}

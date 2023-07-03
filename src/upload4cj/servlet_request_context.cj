/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

from net import http.*

/**
 * ServletRequestContext
 */
public class ServletRequestContext <: RequestContext {
    private var request: Request

    /**
     * init
     *
     * @param request - Request The Request
     */
    public init(request: Request) {
        this.request = request
    }

    /**
     * get the CharacterEncoding
     *
     * @return Option<String> - The CharacterEncoding
     */
    public override func getCharacterEncoding(): Option<String> {
        return FileUploadBase.CHARACTER_ENCODING
    }

    /**
     * get contentType
     *
     * @return Option<String> - The contentType
     */
    public override func getContentType(): Option<String> {
        return request.header.get(FileUploadBase.CONTENT_TYPE)
    }

    /**
     * get contentLength
     *
     * @return Int64 - The content Length
     */
    public override func contentLength(): Int64 {
        var size: Int64
        try {
            let contentLength: String = request.header.get(FileUploadBase.CONTENT_LENGTH).getOrThrow()
            size = Int64.parse(contentLength)
        } catch (e: Exception) {
            size = request.contentLength
        }
        return size
    }

    /**
     * get InputStream
     *
     * @return InputStream - The InputStream
     */
    public override func getInputStream(): InputStream {
        return request.body
    }

    /**
     * toString
     *
     * @return String - toString
     */
    public func toString(): String {
        return "ContentLength = ${this.contentLength()}, ContentType = ${this.getContentType()}"
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights resvered.
 */

package upload4cj


/**
 * ServletRequestContext
 */
public class ServletRequestContext <: RequestContext {
    private var request: HttpRequest

    /**
     * init
     *
     * @param request - Request The Request
     */
    public init(request: HttpRequest) {
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
        let conTypeList = request.headers.get(FileUploadBase.CONTENT_TYPE)
        if(conTypeList.size == 0){
            return Option<String>.None
        }else{
            let contentType = request.headers.get(FileUploadBase.CONTENT_TYPE).iterator().next().getOrThrow()
            return Option<String>.Some(contentType)
        }
    }

    /**
     * get contentLength
     *
     * @return Int64 - The content Length
     */
    public override func contentLength(): Int64 {
        var size: Int64
        try {
            let contentLength: String = request.headers.get(FileUploadBase.CONTENT_LENGTH).iterator().next().getOrThrow()
            size = Int64.parse(contentLength)
        } catch (e: Exception) {
            size = request.bodySize.getOrThrow()
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

/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

/**
 * RequestContext
 */
public interface RequestContext {
    func getCharacterEncoding(): Option<String>

    func getContentType(): Option<String>

    func contentLength(): Int64

    func getInputStream(): InputStream
}

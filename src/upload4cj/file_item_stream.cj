/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

/**
 * FileItemStream
 */
public interface FileItemStream <: FileItemHeadersSupport {
    func openStream(): InputStream

    func getContentType(): String

    func getName(): Option<String>

    func getFieldName(): String

    func isFormField(): Bool
}

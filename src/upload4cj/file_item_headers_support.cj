/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

/**
 * FileItemHeadersSupport
 */
public interface FileItemHeadersSupport {
    func getHeaders(): FileItemHeaders

    func setHeaders(headers: FileItemHeaders): Unit
}

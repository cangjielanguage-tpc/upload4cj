/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package cangjie_tpc::upload4cj

/**
 * FileItemHeaders
 */
public interface FileItemHeaders {
    func getHeader(name: String): Option<String>

    func getHeaders(name: String): Iterator<String>

    func getHeaderNames(): Iterator<String>
}

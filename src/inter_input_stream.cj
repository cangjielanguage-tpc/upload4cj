/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package cangjie_tpc::upload4cj

/**
 * InterInputStream
 */
public interface InterInputStream <: InputStream {
    func close(): Unit
}

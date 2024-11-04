/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package upload4cj

/**
 * InterInputStream
 */
public interface InterInputStream <: InputStream {
    func close(): Unit
}

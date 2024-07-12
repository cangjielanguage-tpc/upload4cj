/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights resvered.
 */

package upload4cj

/**
 * InterInputStream
 */
public interface InterInputStream <: InputStream {
    func close(): Unit
}

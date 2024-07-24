/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights resvered.
 */

package upload4cj

/**
 * ProgressListener
 */
public interface ProgressListener {
    func update(pBytesRead: Int64, pContentLength: Int64, pItems: Int64): Unit
}

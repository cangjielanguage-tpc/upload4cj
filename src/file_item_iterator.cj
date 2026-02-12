/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package cangjie_tpc::upload4cj

/**
 * FileItemIterator
 */
public interface FileItemIterator {
    func hasNext(): Bool

    func next(): FileItemStream
}

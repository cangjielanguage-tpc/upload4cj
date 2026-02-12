/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package cangjie_tpc::upload4cj

/**
 * FileItemFactory
 */
public interface FileItemFactory {
    func createItem(var1: String, var2: String, var3: Bool, var4: String): FileItem
}

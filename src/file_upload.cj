/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package cangjie_tpc::upload4cj

/**
 * FileUpload
 */
public open class FileUpload <: FileUploadBase {
    private var fileItemFactory = Option<FileItemFactory>.None

    /**
     * init
     */
    public init() {
        super()
    }

    /**
     * init
     *
     * @param fileItemFactory - Option<FileItemFactory> the FileItemFactory
     */
    public init(fileItemFactory: Option<FileItemFactory>) {
        super()
        this.fileItemFactory = fileItemFactory
    }

    /**
     * get The File ItemFactory
     *
     * @return Option<FileItemFactory> - The File ItemFactory
     */
    public override func getFileItemFactory(): Option<FileItemFactory> {
        return fileItemFactory
    }

    /**
     * set The File ItemFactory
     *
     * @param factory - Option<FileItemFactory> The File ItemFactory
     */
    public override func setFileItemFactory(factory: Option<FileItemFactory>) {
        this.fileItemFactory = factory
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights resvered.
 */

package upload4cj

/**
 * Files are created in the system default temp directory with
 * predictable names
 */
public class DiskFileItemFactory <: FileItemFactory {
    public static let DEFAULT_SIZE_THRESHOLD: Int64 = 10240

    private var sizeThreshold: Int64 = DEFAULT_SIZE_THRESHOLD

    private var repository: Option<Directory> = Option<Directory>.None

    private var defaultCharset: String = DiskFileItem.DEFAULT_CHARSET

    /**
     * init
     */
    public init() {
        this(DEFAULT_SIZE_THRESHOLD, Option<Directory>.None)
    }

    /**
     * init
     *
     * @param sizeThreshold - Int64 The threshold
     * @param repository - Option<Directory> The data repository
     */
    public init(sizeThreshold: Int64, repository: Option<Directory>) {
        this.sizeThreshold = sizeThreshold
        this.repository = repository
    }

    /**
     * get the data repository
     *
     * @return Option<Directory> - The data repository
     */
    public func getRepository(): Option<Directory> {
        return repository
    }

    /**
     * set the data repository
     *
     * @param tempRepository - Option<Directory> The data repository
     */
    public func setRepository(tempRepository: Option<Directory>): Unit {
        this.repository = tempRepository
    }

    /**
     * get The threshold
     *
     * @return Int64 - the threshold
     */
    public func getSizeThreshold(): Int64 {
        return sizeThreshold
    }

    /**
     * set The threshold
     *
     * @param sizeThreshold - Int64 the threshold
     */
    public func setSizeThreshold(tempSizeThreshold: Int64): Unit {
        this.sizeThreshold = tempSizeThreshold
    }

    /**
     * create the Item
     *
     * @param fieldName - String fieldName
     * @param contentType - String contentType
     * @param isFormField - Bool isFormField or not
     * @param fileName - String fileName
     *
     * @return FileItem - the Item
     */
    public override func createItem(fieldName: String, contentType: String, isFormField: Bool, fileName: String): FileItem {
        return DiskFileItem(fieldName, contentType, isFormField, fileName, sizeThreshold, repository)
    }

    /**
     * get the default Charset
     *
     * @return String - default Charset
     */
    public func getDefaultCharset(): String {
        return defaultCharset
    }

    /**
     * set the default Charset
     *
     * @param pCharset - String the default Charset
     */
    public func setDefaultCharset(pCharset: String): Unit {
        defaultCharset = pCharset
    }
}

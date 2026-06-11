package cangjie_tpc::upload4cj

/**
 * FileItem
 */
public interface FileItem <: FileItemHeadersSupport {
    func getInputStream(): Option<InputStream>

    func getContentType(): String

    func getName(): String

    func isInMemory(): Bool

    func getSize(): Int64

    func get(): Option<Array<UInt8>>

    func getString(): String

    func write(file: File): Unit

    func delete(): Unit

    func getFieldName(): String

    func setFieldName(name: String): Unit

    func isGetFormField(): Bool

    func setFormField(state: Bool): Unit

    func getOutputStream(): OutputStream
}

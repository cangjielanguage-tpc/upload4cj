package cangjie_tpc::upload4cj

/**
 * FileItemIterator
 */
public interface FileItemIterator {
    func hasNext(): Bool

    func next(): FileItemStream
}

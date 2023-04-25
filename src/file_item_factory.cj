package upload4cj

public interface FileItemIterator{

    func hasNext():Bool

    func next():FileItemStream

}

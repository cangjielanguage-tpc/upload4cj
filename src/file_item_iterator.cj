package upload4cj

public interface FileItemFactory{

    func createItem(fieldName:String,contentType:String,isFormField:Bool,fileName:String):FileItem

}

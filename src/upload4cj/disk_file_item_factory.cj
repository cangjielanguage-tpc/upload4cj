package upload4cj

public class DiskFileItemFactory <: FileItemFactory {


    public override func createItem(fieldName: String, contentType: String, isFormField: Bool, fileName: String) :FileItem{
        return DiskFileItem(fieldName, contentType, isFormField, fileName, 3, File("", OpenOption.Create(true)))
    }

}


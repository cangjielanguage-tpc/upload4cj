package upload4cj.disk

public class DiskFileItemFactory <: FileItemFactory {


    public override func createItem(var1: String, var2: String, var3: Bool, var4: String) :FileItem{
        return DiskFileItem()
    }

}


// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib:upload4cj/build/cryptocj
// 3rd_party_lib:upload4cj/build/uuid

from upload4cj import upload4cj.*
from std import fs.*
from std import io.*
from std import collection.*
from net import http.*

@Test
public class TestDiskFileItem {
    /***
        public init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int64, repository: Option<Directory>)
        public override func isInMemory(): Bool
        测试场景:: repository非空且OutputStream有值，无空异常且返回true
    ***/
    @TestCase
    func testDiskFileItemIsInMemory02(): Unit {
        let dirPath:Path = Path("./dirfactory")
        if(!Directory.exists(dirPath)) {
            Directory.create(dirPath)
        }
        var dir = Directory(dirPath)
        let dfs = DiskFileItem("a1" , "text/html; charset=utf16" , false, "testfile" , 129 , dir)
        var flag= 0
        try {
            var out = dfs.getOutputStream()
            out.write([45,23,22,43])
            var res = dfs.isInMemory()
            @Assert(res, true)
        } catch (e: NoneValueException) {
            flag =1
        }
        @Assert(flag, 0)
    }
}
// 3rd_party_lib:upload4cj/build/charset
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/charset
// 3rd_party_lib:upload4cj/build/crypto4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/crypto4cj
// 3rd_party_lib:upload4cj/build/upload4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/upload4cj
// 3rd_party_lib:upload4cj/build/uuid4cj
// 3rd_party_lib_ohos:upload4cj/build/aarch64-linux-ohos/uuid4cj

import upload4cj.*
import std.fs.*
import std.io.*
import std.collection.*
import net.http.*

@Test
public class TestFileUploadBase {
    /***
        public init()
        public func setProgressListener(pListener:Option<ProgressListener>):Unit
        测试场景:  set后获取到set的值
    ***/
    @TestCase
    func testFileUploadBaseSetProgressListener01(): Unit {
        var fu = FileUpload()
        fu.setProgressListener(ProgressListenerImpl(12, 5))
        var flag = 1
        match (fu.getProgressListener()) {
            case Some(_) => flag = 0
            case None => flag = 1
        }
        @Assert(flag, 0)
    }
}

public class ProgressListenerImpl <: ProgressListener {
    private let expectedContentLength: Int64
    private let expectedItems: Int64
    private var bytesRead: Int64 = 0
    private var items: Int64 = 0

    public init(pContentLength: Int64, pItems: Int64) {
        expectedContentLength = pContentLength
        expectedItems = pItems
    }

    public override func update(pBytesRead: Int64, pContentLength: Int64, pItems: Int64) {
        pContentLength.toString()
        bytesRead = pBytesRead
        items = pItems
    }

    public func checkFinished(): Int64 {
        return 0
    }
}

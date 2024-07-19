# upload4cj 库

## 介绍

upload4cj是用于处理浏览器或者其他客户端上传上来的单个或者多个文件的一个文件报文解析组件(注:这里的文件指字段和文件两部分)

## 1. 组件上传

### 1.1 组件上传

#### 1.1.1 主要接口

```
public abstract class FileUploadBase {
	/**
     * 解析请求获取FileItem集合
     *
     * 参数 ctx - RequestContext 请求对象
     * 返回值 - Option<ArrayList<FileItem>> 解析出来的FileItem集合
     * NullPointerException异常:当FileItemFactory为空的时候会抛出该异常
     * FileCountLimitExceededException异常:当Fileitem的数量超过最大限制数时候会抛出该异常
     * FileUploadException异常:当解析出错的时候会抛出该异常
     * ReadWriteException异常:当IO流读取写入发生异常时候会抛出该异常
     */
    public func parseRequest(ctx: RequestContext): Option<ArrayList<FileItem>>

    /**
     * 获取Map形式的FileItem集合
     *
     * 参数 ctx - RequestContext 请求对象
     * 返回值 - Map<String,ArrayList<FileItem>> Map形式的FileItem集合
     */
    public func parseParameterMap(ctx:RequestContext):Map<String,ArrayList<FileItem>>
}
```

#### 1.1.1 示例

```cangjie
import upload4cj.*
import net.http.*
import std.io.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main() {
    let ccc = Test_FeatureApi()
    ccc.execute()
    ccc.printResult()
    0
}

@Test
public class Test_FeatureApi{

    let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"

    @TestCase
    func test_featureApi_01() {
      let text =
            "-----1234\r\n" +
            "content-disposition: form-data; name=\"field1\"\r\n" +
            "\r\n" +
            "Joe Blow\r\n" +
            "-----1234\r\n" +
            "content-disposition: form-data; name=\"pics\"\r\n" +
            "Content-type: multipart/mixed, boundary=---9876\r\n" +
            "\r\n" +
            "-----9876\r\n" +
            "Content-disposition: attachment; filename=\"file1.txt\"\r\n" +
            "Content-Type: text/plain\r\n" +
            "\r\n" +
            "... contents of file1.txt ...\r\n" +
            "-----9876--\r\n" +
            "-----1234--\r\n"

        let bytes: Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/")
                   .body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let fileItemFactory: DiskFileItemFactory = DiskFileItemFactory()
        let upload: ServletFileUpload = ServletFileUpload(fileItemFactory)
        let fileItems: ArrayList<FileItem> = upload.parseRequest(req1).getOrThrow()
        let field: FileItem = fileItems.get(0).getOrThrow()
        @Assert(field.getFieldName(),"field1")
        @Assert(field.isGetFormField(),true)
        @Assert(field.getString(),"Joe Blow")
    }
}

```
执行结果如下：

```
[ PASSED ] CASE: test_featureApi_01
```
#### 1.1.2 示例

```cangjie
import upload4cj.*
import net.http.*
import std.io.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main() {
    let ccc = Test_FeatureApi()
    ccc.execute()
    ccc.printResult()
    0
}

@Test
public class Test_FeatureApi{

    let CONTENT_TYPE: String = "multipart/form-data; boundary=---1234"

    @TestCase
    func test_featureApi_02 () {
      let text =
            "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"file\"; filename=\"foo.tab\"\r\n" +
            "Content-Type: text/whatever\r\n" +
            "\r\n" +
            "This is the content of the file\n" +
            "\r\n" +
            "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"field\"\r\n" +
            "\r\n" +
            "fieldValue\r\n" +
            "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" +
            "\r\n" +
            "value1\r\n" +
            "-----1234\r\n" +
            "Content-Disposition: form-data; name=\"multi\"\r\n" +
            "\r\n" +
            "value2\r\n" +
            "-----1234--\r\n"

        let bytes: Array<UInt8> = text.toUtf8Array()
        var output = ByteArrayStream()
        output.write(bytes)
        var req1 = HttpRequestBuilder().method("POST").url("http://127.0.0.1/")
                   .body(output).build()
        req1.headers.add("Content-Type", CONTENT_TYPE)
        let upload: ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
        let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)
        @Assert(mappedParameters.contains("file"),true)
        @Assert(mappedParameters.get("file").getOrThrow().size,1)
        @Assert(mappedParameters.contains("field"),true)
        @Assert(mappedParameters.get("field").getOrThrow().size,1)
        @Assert(mappedParameters.contains("multi"),true)
        @Assert(mappedParameters.get("multi").getOrThrow().size,2)
    }

}


```
执行结果如下：

```
[ PASSED ] CASE: test_featureApi_02
```


## 2 其他接口

#### 2.1 DeferredFileOutputStream

```
public class DeferredFileOutputStream <: ThresholdingOutputStream {

    /**
     * DeferredFileOutputStream构造函数
     *
     * 参数 threshold - Int64 内存和本地存储的分解阈值
     * 参数 tempFile - Option<File> 本地存储的文件
     * 参数 repository - Option<Directory> 本地存储的目录
     */
    public init(threshold: Int64, tempFile: Option<File>,repository:Option<Directory>)

    /**
     * 关闭流的方法
     */
    public func close(): Unit

    /**
     * 获取内存中的数据
     *
     * 返回值 - Option<Array<UInt8>> 内存中数据的字节数组形式
     */
    public func getData(): Option<Array<UInt8>>

    /**
     * 本地存储时候的文件对象，注意只有写，并且写的时候达到阈值的时候才会创建文件，否则返回Option<File>.None
     *
     * 返回值 - File 本地存储时候的文件对象
     */
    public func getFile(): Option<File>

    /**
     * 是否存储在内存
     *
     * 返回值 - Bool true存储在内存 false存储在本地
     */
    public func isInMemory(): Bool

}
```

#### 2.2  DiskFileItemFactory

```
public class DiskFileItemFactory implements FileItemFactory{
    /**
    * 初始化
    */
    public init()

    /**
    * 初始化
    *
    * 参数 sizeThreshold - Int64 阀值
    * 参数 repository - Option<Directory> 存储目录
    */
    public init(sizeThreshold: Int64, repository: Option<Directory>)

    /**
    * 创建Item对象
    *
    * 参数 fieldName - String 字段名称
    * 参数 contentType - String 文本类型
    * 参数 isFormField - Bool 普通文本表单字段，还是一个文件表单字段
    * 参数 fileName - String 文件名称
    */
    public override func createItem(fieldName: String, contentType: String, isFormField: Bool, fileName: String): FileItem

   	/**
    * 返回默认的字符集
    *
    * 返回值 String - 默认的字符集
    */
    public func getDefaultCharset(): String

    /**
    * 设置默认的字符集
    *
    * 参数 pCharset - String 默认的字符集
    */
    public func setDefaultCharset(pCharset: String): Unit

    /**
    * 获取存储文件的目录
    *
    * 返回值 Directory - 存储文件的目录
    */
    public func getRepository():Option<Directory>

    /**
    * 设置存储文件的目录
    *
    * 参数 repository - Directory 存储文件的目录
    */
    public func setRepository(tempRepository:Option<Directory>):Unit

    /**
    * 获取内容超过多大字节时候存文件的阈值
    *
    * 返回值 Int64 - 内容超过多大字节时候存文件的阈值
    */
    public func getSizeThreshold():Int64

    /**
    * 设置内容超过多大字节时候存文件的阈值
    *
    * 参数 sizeThreshold - Int64 内容超过多大字节时候存文件的阈值
    */
    public func setSizeThreshold(sizeThreshold:Int64):Unit

}

```

#### 2.3  DiskFileItem

```
public class DiskFileItem implements FileItem{
    /**
    * 初始化
    *
    * 参数 fieldName - String 字段名称
    * 参数 contentType - String 内容类型
    * 参数 isFormField - Bool 是否是普通文本表单字段
    * 参数 fileName - String 文件名称
    * 参数 sizeThreshold - Int64 阈值
    * 参数 repository - Option<Directory> 存储仓库目录
    */
    public init(fieldName: String, contentType: String, isFormField: Bool, fileName: String, sizeThreshold: Int64, repository: Option<Directory>)

    /**
    * 返回内容类型
    *
    * 返回值 String - 内容类型
    /
    public override func getContentType(): String

    /**
    * 返回字符集
    *
    * 返回值 String - 字符集
    /
    public func getCharSet(): String

    /**
    * 返回item里的文件名称
    *
    * 返回值 String - item里的文件名称
    /
    public override func getName(): String

    /**
    * 是否保存在内存
    *
    * 返回值 Bool - 是否保存在内存
    * NoneValueException异常:当前diskFileItem对象未获取对应的输出流对象时候，会抛此异常
    /
    public override func isInMemory(): Bool

    /**
    * 获取文本大小
    *
    * 返回值 Int64 - 文本大小
    * NoneValueException异常:当前diskFileItem对象未获取对应的输出流对象时候，会抛此异常
    /
    public override func getSize(): Int64

    /**
    * 获取文本的字节数组
    *
    * 返回值 Option<Array<UInt8>> - 文本的字节数组
    * NoneValueException异常:当前diskFileItem对象未获取对应的输出流对象时候，会抛此异常
    /
    public override func get(): Option<Array<UInt8>>

    /**
    * 获取文本
    *
    * 返回值 String - 文本
    * NoneValueException异常:当前diskFileItem对象未获取对应的输出流对象时候，会抛此异常
    /
    public override func getString(): String

    /**
    * 获取字段名称
    *
    * 返回值 String - 字段名称
    /
    public override func getFieldName(): String

    /**
    * 设置字段名称
    *
    * 参数 fieldName - String 字段名称
    /
    public override func setFieldName(fieldName: String) //设置字段名称

    /**
    * 是否是普通文本表单字段
    *
    * 返回值 Bool - 是否是普通文本表单字段
    /
    public func isGetFormField(): Bool

    /**
    * 设置是否是普通文本表单字段
    *
    * 参数 State - Bool 是否是普通文本表单字段
    /
    public override func setFormField(state: Bool)

    /**
    * 获取输出流
    *
    * 返回值 OutputStream 输出流
    /
    public override func getOutputStream(): OutputStream

    /**
    * 获取文件头
    *
    * 返回值 FileItemHeaders 文件头对象
    /
    public override func getHeaders(): FileItemHeaders

    /**
    * 设置文件头
    *
    * 参数 pHeaders - FileItemHeaders 文件头对象
    /
    public override func setHeaders(pHeaders: FileItemHeaders)

    /**
    * 获取字符集
    *
    * 返回值 String - 字符集
    /
    public func getDefaultCharset():String

    /**
    * 设置字符集
    *
    * 参数 charset - String 字符集
    /
    public func setDefaultCharset(charset:String):Unit

    /**
    * 获取fileItem的输入流对象
    *
    * 返回值 Option<InputStream> - fileItem的输入流对象
    * NoneValueException异常:当前diskFileItem对象未获取对应的输出流对象时候，会抛此异常
    /
    public override func getInputStream(): Option<InputStream>

    /**
    * 把fileItem的内容写入file
    *
    * 参数 file - File 要写入的文件
    * ParseException异常:当文件写入内容出现异常的时候会抛出该异常；
    * FileUploadException异常:如果是硬盘缓存类型，并且没有对应的本地可写入file,就会抛出该异常
    * NoneValueException异常:当前diskFileItem对象未获取对应的输出流对象时候，会抛此异常
    /
    public override func write(file:File)

    /**
    * 删除fileItem的保存内容到本地的文件并清空内存
    *
    /
    public override func delete()

    /**
    * 获取存储本地的文件对象
    *
    * 返回值 Option<File> - 存储本地的文件对象
    /
    public func getStoreLocation(): Option<File>

    /**
    * fileItem的toString表示
    *
    * 返回值 String - fileItem的toString表示
    * NoneValueException异常:当前diskFileItem对象未获取对应的输出流对象时候，会抛此异常
    /
    public func toString():String

}
```

#### 2.4  FileItemFactory

```
public interface FileItemFactory {

    /**
     * 创建FileItem对象
     *
     * 参数 fieldName - FileItem的fieldName
     * 参数 contentType - FileItem的contentType
     * 参数 isFormField - FileItem是否是表单字段 true是 false不是
     * 参数 fileName - FileItem对应的文件名
     */
    func createItem(fieldName: String, contentType: String, isFormField: Bool, fileName: String): FileItem

}
```

#### 2.5 FileItemHeadersImpl

```
public class FileItemHeadersImpl <: FileItemHeaders {

	/**
     * 获取对应header的value值
     *
     * 参数 name - String header的key
     * 返回值 - Option<String> 对应的value值
     */
    public override func getHeader(name:String): Option<String>

    /**
     * 获取所有的key
     *
     * 返回值 - Iterator<String> 所有key的迭代器
     */
    public override func getHeaderNames(): Iterator<String>

    /**
     * 获取所有的value
     *
     * 参数 name - String header的key
     * 返回值 - Iterator<String> 所有value的迭代器
     */
	public override func getHeaders(name:String): Iterator<String>

	/**
     * 添加新header
     *
     * 参数 name - String header的key
     * 参数 value - String header的value
     */
	public func addHeader(name:String,value:String):Unit
}
```

####  2.6 FileItemHeadersSupport

```
public interface FileItemHeadersSupport {

    /**
     * 获取FileItem的Headers
     *
     * 返回值 - FileItemHeaders FileItem的Headers
     */
    func getHeaders(): FileItemHeaders

    /**
     * 设置FileItem的Headers
     *
     * 参数 headers - 要设置的FileItem的Headers
     */
    func setHeaders(headers: FileItemHeaders): Unit

}
```

#### 2.7 FileItemHeaders

```
public interface FileItemHeaders {

    /**
     * 根据key获取value
     *
     * 参数 name - header的key
     * 返回值 - Option<String> 该key对应的value
     */
    func getHeader(name: String): Option<String>

    /**
     * 获取key对应的value的迭代器
     *
     * 参数 name - header的key
     * 返回值 - Iterator<String> 该key对应的value的迭代器
     */
    func getHeaders(name: String): Iterator<String>

     /**
     * 获取header中所有key组合成的迭代器
     *
     * 返回值 - Iterator<String> 所有key组成的迭代器
     */
    func getHeaderNames(): Iterator<String>

}
```

#### 2.8 FileItemIteratorImpl

```
public class FileItemIteratorImpl <: FileItemIterator {

    /**
     * 是否还有下一个FileItemStream
     *
     * 返回值 - Bool true有 false没有
     * FileUploadException异常: 分析或处理fileitem失败的时候会抛该异常
     */
    public override func hasNext(): Bool

    /**
     * 获取下一个FileItemStream
     *
     * 返回值 - FileItemStream 下一个FileItemStream
     * NoSuchElementException异常:当没有更多可用的item的时候会报该异常
     */
    public override func next(): FileItemStream

}
```

#### 2.9 FileItemIterator

```
public interface FileItemIterator {

    /**
     * 是否还有下一个FileItemStream
     *
     * 返回值 - Bool true有 false没有
     */
    func hasNext(): Bool

    /**
     * 获取下一个FileItemStream
     *
     * 返回值 - FileItemStream 下一个FileItemStream
     */
    func next(): FileItemStream

}
```

#### 2.10 FileItemStreamImpl

```
public class FileItemStreamImpl <: FileItemStream {

    /**
     * 获取FileItemStream的ContentType
     *
     * 返回值 - String FileItemStream的ContentType
     */
    public override func getContentType(): String

    /**
     * 获取FileItemStream的FieldName
     *
     * 返回值 - String FileItemStream的FieldName
     */
    public override func getFieldName(): String

    /**
     * 获取FileItemStream的Name
     *
     * 返回值 - Option<String> FileItemStream的Name
     */
    public override func getName(): Option<String>

    /**
     * 判断这个FileItemStream是不是表单字段类型
     *
     * 返回值 - Bool true是 false不是
     */
    public override func isFormField(): Bool

     /**
     * 获取FileItemStream的InputStream
     *
     * 返回值 - InputStream FileItemStream的InputStream
     * IllegalStateException异常:当流已经打开的时候再去打开就会抛该异常
     */
    public override func openStream(): InputStream

     /**
     * 获取FileItemStream的Headers
     *
     * 返回值 - FileItemHeaders FileItemStream的Headers
     */
    public override func getHeaders(): FileItemHeaders

     /**
     * 设置FileItemStream的Headers
     *
     * 参数 pHeaders - 要设置的FileItemStream的Headers
     */
    public override func setHeaders(pHeaders: FileItemHeaders): Unit

}
```

#### 2.11 FileItemStream

```
public interface FileItemStream <: FileItemHeadersSupport{

    /**
     * 获取FileItemStream的ContentType
     *
     * 返回值 - String FileItemStream的ContentType
     */
    func getContentType():String

    /**
     * 获取FileItemStream的FieldName
     *
     * 返回值 - String FileItemStream的FieldName
     */
    func getFieldName():String

    /**
     * 获取FileItemStream的Name
     *
     * 返回值 - Option<String> FileItemStream的Name
     */
    func getName():Option<String>

    /**
     * 判断这个FileItemStream是不是表单字段类型
     *
     * 返回值 - Bool true是 false不是
     */
    func isFormField():Bool

     /**
     * 获取FileItemStream的InputStream
     *
     * 返回值 - InputStream FileItemStream的InputStream
     */
    func openStream():InputStream

}
```

#### 2.12 FileItem

```
public interface FileItem <: FileItemHeadersSupport {
	/**
     * 获取FileItem的输入流
     *
     * 返回值 - Option<InputStream> FileItem的输入流
     */
    func getInputStream(): Option<InputStream>

    /**
     * 获取FileItem的ContentType
     *
     * 返回值 - String FileItem的ContentType
     */
    func getContentType(): String

    /**
     * 获取FlieItem的文件名称
     *
     * 返回值 - String FlieItem的文件名称
     */
    func getName(): String

    /**
     * 判断该FileItem是不是存储在内存
     *
     * 返回值 - Bool true是在内存 false在本地文件
     */
    func isInMemory(): Bool

    /**
     * 获取fileItem的内容长度
     *
     * 返回值 - Int64 fileItem的内容长度
     */
    func getSize(): Int64

     /**
     * 获取FileItem内容的字节数组形式
     *
     * 返回值 - Option<Array<UInt8>> FileItem内容的字节数组形式
     */
    func get(): Option<Array<UInt8>>

     /**
     * 获取FileItem内容的字符串形式
     *
     * 返回值 - String FileItem内容的字符串形式
     */
    func getString(): String

     /**
     * 把fileItem的内容写入指定file对象
     *
     * 参数 file -  要写入的指定文件对象
     */
    func write(file: File): Unit

     /**
     * 删除fileItem的保存内容到本地的文件并清空内存
     *
     */
    func delete(): Unit

     /**
     * 获取FileItem的fieldName
     *
     * 返回值 - String FileItem的fieldName
     */
    func getFieldName(): String

     /**
     * 设置FileItem的fieldName
     *
     * 参数 name -  要设置的fieldName
     */
    func setFieldName(name: String): Unit

     /**
     * 判断该FileItem是不是字段类型
     *
     * 返回值 - Bool true是字段类型 false文件类型
     */
    func isGetFormField(): Bool

     /**
     * 设置FileItem是字段类型还是文件类型
     *
     * 参数 state - true是字段类型 false文件类型
     */
    func setFormField(state: Bool): Unit

     /**
     * 获取FileItem的输出流对象
     *
     * 返回值 - OutputStream FileItem的输出流对象
     */
    func getOutputStream(): OutputStream

}
```

#### 2.13 FileUploadBase

```
public abstract class FileUploadBase {
	/**
     * 解析请求获取FileItem集合
     *
     * 参数 ctx - RequestContext 请求对象
     * 返回值 - Option<ArrayList<FileItem>> 解析出来的FileItem集合
     * NullPointerException异常:当FileItemFactory为空的时候会抛出该异常
     * FileCountLimitExceededException异常:当Fileitem的数量超过最大限制数时候会抛出该异常
     * FileUploadException异常:当解析出错的时候会抛出该异常
     * ReadWriteException异常:当IO流读取写入发生异常时候会抛出该异常
     */
    public func parseRequest(ctx: RequestContext): Option<ArrayList<FileItem>>

    /**
     * 获取Map形式的FileItem集合
     *
     * 参数 ctx - RequestContext 请求对象
     * 返回值 - Map<String,ArrayList<FileItem>> Map形式的FileItem集合
     */
    public func parseParameterMap(ctx:RequestContext):Map<String,ArrayList<FileItem>>

    /**
     * 解析获取FileItem的迭代器
     *
     * 参数 ctx - RequestContext 请求对象
     * 返回值 - FileItemIterator FileItem的迭代器
     * FileUploadException异常:如果读取或者解析出现问题的时候会抛出该异常
     * InvalidContentTypeException异常:当contentType为空或者不是以multipart/开头的时候会报这个异常
     */
    public func getItemIterator(ctx: RequestContext): FileItemIterator

    /**
    * 判断请求是不是MultiPart类型
    *
    * 参数 ctx - RequestContext 请求对象
    * 返回值 Bool - true 是  false 不是
    */
    public static func isMultipartContent(ctx:RequestContext):Bool

    /**
    * 获取FileItemFactory对象
    *
    * 返回值 Option<FileItemFactory> - FileItemFactory对象
    */
    public func getFileItemFactory(): Option<FileItemFactory>

   /**
    * 设置FileItemFactory对象
    *
    * 参数 factory - 要设置的FileItemFactory对象
    */
    public func setFileItemFactory(factory: Option<FileItemFactory>): Unit

    /**
    * 设置FileItem内容大小的最大阈值
    *
    * 参数 fileSizeMax - Int64 FileItem内容的最大阈值
    */
    public func setFileSizeMax(fileSizeMax:Int64):Unit

    /**
    * 获取FileItem内容大小的最大阈值
    *
    * 返回值 Int64 - FileItem内容大小的最大阈值
    */
    public func getFileSizeMax():Int64

    /**
    * 设置request内容大小的最大阈值
    *
    * 参数 sizeMax - Int64 request内容大小的最大阈值
    */
    public func setSizeMax(sizeMax:Int64)

    /**
    * 获取request内容大小的最大阈值
    *
    * 返回值 Int64 - request内容大小的最大阈值
    */
    public func getSizeMax():Int64

    /**
    * 设置一个request里面FileItem的最大数量阈值
    *
    * 参数 fileCountMax - Int64 一个request里面FileItem的最大数量阈值
    */
    public func setFileCountMax(fileCountMax:Int64):Unit

    /**
    * 获取一个request里面FileItem的最大数量阈值
    *
    * 返回值 Int64 - 一个request里面FileItem的最大数量阈值
    */
    public func getFileCountMax():Int64

    /**
    * 设置请求头里的编码
    *
    * 参数 encoding - Option<String> 请求头里的编码
    */
    public func setHeaderEncoding(encoding:Option<String>):Unit

    /**
    * 获取请求头里的编码
    *
    * 返回值 Option<String> - 请求头里的编码
    */
    public func getHeaderEncoding():Option<String>

    /**
    * 设置监听器对象
    *
    * 参数 pListener - Option<ProgressListener> 监听器对象
    */
    public func setProgressListener(pListener:Option<ProgressListener>):Unit

    /**
    * 获取监听器对象
    *
    * 返回值 Option<ProgressListener> - 监听器对象
    */
    public func getProgressListener():Option<ProgressListener>

}
```

#### 2.14 FileUpload

```
public open class FileUpload <: FileUploadBase {
	/**
     * 无参构造函数
     *
     */
    public init()

    /**
     * 一个参数的构造函数
     *
     * 参数 fileItemFactory -  FileItem工厂对象
     */
    public init(fileItemFactory: Option<FileItemFactory>)

    /**
     * 获取FlieItem创建工厂
     *
     * 返回值 - Option<FileItemFactory> FileItem工厂对象
     */
    public override func getFileItemFactory(): Option<FileItemFactory>

    /**
     * 设置FileItem工厂对象
     *
     * 参数 factory -  要设置的FileItem工厂对象
     */
    public override func setFileItemFactory(factory: Option<FileItemFactory>)

}
```

#### 2.15 InterInputStream

```
public interface InterInputStream <: InputStream {

    /**
     * close方法
     *
     */
    func close(): Unit

}
```

#### 2.16 LimitedInputStream

```
public abstract class LimitedInputStream <: InterInputStream {

    /**
     * 构造函数
     *
     * 参数 inputStream - 输入流对象
     * 参数 pSizeMax - 最大阈值
     */
    public init(inputStream: InputStream, pSizeMax: Int64)

    /**
     * read方法
     *
     * 参数 buffer - 将内容读到buffer中
     * 返回值 - Int64 读了多少字节
     */
    public override func read(buffer: Array<UInt8>): Int64

    /**
     * close方法
     *
     */
    public override func close(): Unit

}
```

#### 2.17 MimeUtility

```
public class MimeUtility {

	/**
     * 解析编码的文本
     *
     * 参数 - String 要解码的文本
     * 返回值 - Option<String> 解码后的文本
     */
	public static func decodeText(text: String): Option<String>
}
```

#### 2.18 MultipartStream

```
public class MultipartStream {

    /**
     * MultipartStream 初始化
     *
     * 参数 input - InputStream 文本信息输入流
     * 参数 boundary - Option<Array<UInt8>> 分隔符
     * 参数 bufSize - Int64 读取size
     * 参数 pNotifier - Option<ProgressNotifier> 监听器
     * IllegalArgumentException异常:如果boundary为Option<Array<UInt8>>.None 或者 bufSize小于boundary解构后内容的长度+5 会抛出该异常
     */
    public init (input: InputStream, boundary: Option<Array<UInt8>>, bufSize: Int64, pNotifier: Option<ProgressNotifier>)

    /**
     * MultipartStream 初始化
     *
     * 参数 input - InputStream 文本信息输入流
     * 参数 boundary - Option<Array<UInt8>> 分隔符
     * 参数 pNotifier - Option<ProgressNotifier> 监听器
     */
    public init (input: InputStream, boundary: Option<Array<UInt8>>, pNotifier: Option<ProgressNotifier>)

    /**
     * 获取编码格式
     *
     * 返回值 Option<String> 编码格式
     */
    public func getHeaderEncoding(): Option<String>

    /**
     * 设置编码格式
     *
     * 参数 encoding - Option<String> 编码格式
     */
    public func setHeaderEncoding(encoding: Option<String>)

    /**
     * 读取文件
     *
     * 返回值 UInt8 - 下一个从流中读取的字节
     * ReadWriteException异常:读取不到数据的时候会抛出该异常
     */
    public func readByte(): UInt8

    /**
     * 读取分隔符
     *
     * 返回值 Bool - 是否还有分隔符
     * MalformedStreamException异常:如果流意外结束，或者未能遵循所需的语法会抛出该异常
     * FileUploadIOException异常:如果从流中读取的字节超过大小限制会抛出该异常
     */
    public func readBoundary(): Bool

    /**
     * 设置分隔符
     *
     * 参数 boundary - Array<UInt8> 分隔符的字节数组形式
     * IllegalBoundaryException异常:如果设置的新的boundary的长度和原来的boundary的长度不一致，就会抛出此异常
     */
    public func setBoundary(boundary: Array<UInt8>)

    /**
     * 读取文件头
     *
     * 返回值 String 文件头
     * MalformedStreamException异常:如果从流中读取的字节数超过了大小限制或者流意外结束，会抛出该异常,
     * FileUploadException异常：获取readers逻辑失败的时候会抛出该异常
     */
    public func readHeaders(): String

    /**
     * 从流中读取文件体
     *
     * 参数 output - Option<OutputStream> 输出流
     * 返回值 Int64 读取到的字节大小
     */
    public func readBodyData(output:Option<OutputStream>):Int64

    /**
     * 丢弃读取的文件体
     *
     * 返回值 Int64 丢弃的字节大小
     * MalformedStreamException异常:当MultipartStream的input参数调用read方法读取不到要丢弃的数据时候，就会抛出该异常
     */
    public func discardBodyData():Int64

    /**
     * 忽略序言
     *
     * 返回值 Bool 是否成功
     */
    public func skipPreamble():Bool

    /**
     * 比较两个字节数组是否一致
     *
     * 参数 a - Array<UInt8> 要比较的第一个数组
     * 参数 b - Array<UInt8> 要比较的第二个数组
     * 参数 count - Int64 要比较几个字节
     * 返回值 Bool 是否一致
     * IndexOutOfBoundsException异常,当count比数组a或者数组b长度最小的那个长度大的时候，就会抛出该异常
     */
    public static func arrayequals(a: Array<UInt8>, b: Array<UInt8>, count: Int64): Bool

}
```

#### 2.19 ParameterParser

```
public class ParameterParser {

    /**
     * ParameterParser 解析
     */
    public init ()

    /**
     * 解析
     *
     * 参数 str - Option<String> 需解析的字符串
     * 参数 separators - Option<Array<Char>> 做分隔的Char数组 一般是';',':'等
     * 返回值 - Map<String, Option<String>> 解析后的map
     */
    public func parse(str: Option<String>, separators: Option<Array<Char>>): Map<String, Option<String>>

    /**
     * 解析
     *
     * 参数 str - Option<String> 需解析的字符串
     * 参数 separator - Char 做分隔的Char 一般是';',':'等
     * 返回值 - Map<String, Option<String>> 解析后的map
     */
    public func parse(str: Option<String>, separator: Char): Map<String, Option<String>>

    /**
     * 解析
     *
     * 参数 charArray - Option<Array<Char>> 需解析的Char数组
     * 参数 separator - Char 做分隔的Char 一般是';',':'等
     * 返回值 - Map<String, Option<String>> 解析后的map
     */
    public func parse(charArray: Option<Array<Char>>, separator: Char): Map<String, Option<String>>

    /**
     * 解析
     *
     * 参数 charArray - Option<Array<Char>> 需解析的Char数组
     * 参数 offset - Int64 下标
     * 参数 length - Int64 长度
     * 参数 separator - Char 做分隔的Char 一般是';',':'等
     * 返回值 - Map<String, Option<String>> 解析后的map
     * IndexOutOfBoundsException异常：当offset索引超过charArray长度的时候会抛出该异常
     */
    public func parse(charArray: Option<Array<Char>>, offset: Int64, length: Int64, separator: Char): Map<String, Option<String>>

    /**
     * 获取是否设置name小写
     *
     * 返回值 - Bool
     */
    public func isLowerCaseNames(): Bool

    /**
     * 设置name是否小写
     *
     * 参数 b - Bool 设置name是否小写
     */
    public func setLowerCaseNames(b: Bool)
}

```

#### 2.20 ProgressListener

```
public interface ProgressListener {

    /**
     * 更新上传进度
     *
     * 参数 pBytesRead - 已经读的字节
     * 参数 pContentLength - 内容的字节总数
     * 参数 pItems - 总的item数
     */
    func update(pBytesRead: Int64, pContentLength: Int64, pItems: Int64): Unit

}
```

#### 2.21 ProgressNotifier

```
public class ProgressNotifier {

    /**
     * ProgressNotifier 初始化
     *
     * 参数 pListener - Option<ProgressListener> 进度监听器
     * 参数 pContentLength - Int64 内容长度
     */
    public init(pListener: Option<ProgressListener>, pContentLength: Int64)

}
```

#### 2.22 RequestContext

```
public interface RequestContext {

    /**
     * 获取request字符编码
     *
     * 返回值 - Option<String> request字符编码
     */
    func getCharacterEncoding(): Option<String>

    /**
     * 获取request的ContentType
     *
     * 返回值 - Option<String> request的ContentType
     */
    func getContentType(): Option<String>

    /**
     * 获取request内容长度
     *
     * 返回值 - Int64 request内容长度
     */
    func contentLength(): Int64

    /**
     * 获取request的InputStream
     *
     * 返回值 - InputStream  request的InputStream
     */
    func getInputStream(): InputStream

}
```

#### 2.23 ServletFileUpload

```
public class ServletFileUpload extends FileUpload {
	/**
    * 初始化
    */
	public init()

    /**
    * 初始化
    *
    * 参数 fileItemFactory - FileItemFactory 文本构造工厂类
    */
    public init(fileItemFactory: FileItemFactory)

    /**
    * 生成请求对象
    *
    * 参数 request - Request 请求对象
    * 返回值 Map<String, ArrayList<FileItem>> - 文本对象map
    */
    public func parseParameterMap(request: Request): Map<String, ArrayList<FileItem>>

    /**
    * 解析请求
    *
    * 参数 request - Request 请求对象
    * 返回值 Map<String, ArrayList<FileItem>> - 文本对象列表
    */
    public func parseRequest(request: Request): Option<ArrayList<FileItem>>

    /**
    * 判断请求是不是MultiPart类型
    *
    * 参数 request - Request 请求对象
    * 返回值 Bool - true 是  false 不是
    */
    public static func isMultipartContent(request: Request):Bool

    /**
    * 获取FileItem的迭代器
    *
    * 参数 request - Request 请求对象
    * 返回值 FileItemIterator - FileItem的迭代器
    */
    public func getItemIterator(request:Request):FileItemIterator

}
```

#### 2.24 ServletRequestContext

```
public class ServletRequestContext <: RequestContext {
	/**
     * 初始化
     *
     * 参数 Request - Request 请求体
     */
	public init(request: Request)

	/**
     * 获取编码类型
     *
     * 返回值 - Option<String> 编码类型
     */
	public override func getCharacterEncoding(): Option<String>

	/**
     * 获取contentType
     *
     * 返回值 - Option<String> contentType
     */
	public override func getContentType(): Option<String>

	/**
     * 获取request的body大小
     *
     * 返回值 - Int64 大小
     */
	public override func contentLength(): Int64

	/**
     * 获取request的body输入流
     *
     * 返回值 - InputStream body输入流
     */
	public override func getInputStream(): InputStream

    /**
     * ServletRequestContext的toString形式
     *
     * 返回值 - String ServletRequestContext的toString形式
     */
    public func toString(): String

}
```

#### 2.25 Streams

```
public class Streams {

    /**
     * 复制方法
     *
     * 参数 inputStream - 输入流
     * 参数 outputStream - 输出流
     * 参数 closeOutputStream - 是否关闭流
     * 返回值 - Int64 一共写了多少字节
     * NoneValueException异常：当inputStream为空的时候会抛出该异常
     */
    public static func copy(inputStream:Option<InputStream>,outputStream:Option<OutputStream>,closeOutputStream:Bool):Int64

    /**
     * 复制方法
     *
     * 参数 inputStream - 输入流
     * 参数 outputStream - 输出流
     * 参数 closeOutputStream - 是否关闭流
     * 参数 buffer - 读写缓冲区
     * 返回值 - Int64 一共写了多少字节
     * NoneValueException异常：当inputStream为空的时候会抛出该异常
     */
    public static func copy(inputStream:Option<InputStream>,outputStream:Option<OutputStream>,closeOutputStream:Bool,buffer:Array<UInt8>):Int64

    /**
     * 检查文件名
     *
     * 参数 fileName - 文件名
     * 返回值 - Option<String> 检查后的文件名
     * InvalidFileNameException异常: 如果发现文件名无效会抛出该异常
     */
    public static func checkFileName(fileName:Option<String>):Option<String>

}
```

#### 2.26 ThresholdingOutputStream

```
public abstract class ThresholdingOutputStream <: OutputStream {

    /**
     * 初始化
     *
     * 参数 threshold - 保存内存和本地的界限阈值
     */
    public init(threshold: Int64)

    /**
     * 冲刷流
     *
     */
    public func flush()

    /**
     * 已经写入的字节数
     *
     * 返回值 - Int64 已经写入的字节数
     */
    public func getByteCount(): Int64

    /**
     * 获取阈值
     *
     * 返回值 - Int64 保存内存和本地的界限阈值
     */
    public func getThreshold(): Int64

    /**
     * 是否已经达到阈值
     *
     * 返回值 - Bool true达到 false没达到
     */
    public func isThresholdExceeded(): Bool

    /**
     * 写方法
     *
     * 参数 b - 要写入的内容
     */
    public func write(b: Array<UInt8>)

}
```

#### 2.27 FileUploadException

```
public class FileUploadException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.28 IllegalBoundaryException

```
public class IllegalBoundaryException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.29 MalformedStreamException

```
public class MalformedStreamException <: ReadWriteException {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.30 NullPointerException

```
public class NullPointerException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.31 InvalidContentTypeException

```
public class InvalidContentTypeException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.32 SizeLimitExceededException

```
public class SizeLimitExceededException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.33 UnsupportedEncodingException

```
public class UnsupportedEncodingException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.34 IllegalStateException

```
public class IllegalStateException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.35 NoSuchElementException

```
public class NoSuchElementException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.36 FileCountLimitExceededException

```
public class FileCountLimitExceededException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 获取最大阈值
     *
     * 返回值 - Int64 最大阈值
     */
    public func getLimit(): Int64

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.37 FileSizeLimitExceededException

```
public class FileSizeLimitExceededException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.38 InvalidFileNameException

```
public class InvalidFileNameException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.39 ItemSkippedException

```
public class ItemSkippedException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.40 ParseException

```
public class ParseException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.41 QDecoderException

```
public class QDecoderException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public func toString():String

}
```

#### 2.42 ReadWriteException

```
public open class ReadWriteException <: Exception {

    /**
     * 初始化
     *
     * 参数 messages 异常信息
     */
    public init(messages: String)

    /**
     * 重写toString
     *
     * 返回值 - String 重写的字符串内容
     */
    public open func toString():String

}
```

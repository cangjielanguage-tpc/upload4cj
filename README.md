<div align="center">
<h1>upload4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.39.5-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-91.1%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## <img alt="" src="./doc/assets/readme-icon-introduction.png" style="display: inline-block;" width=3%/> 介绍

commons-fileupload为apache出品的文件上传组件，用来接收浏览器上传的组件

参考地址：https://github.com/apache/commons-fileupload 版本 1.5

**特性**：

- 🚀 解析参数内容的消息头
- 💪 文件上传请求解析器

- 🌍 解析后的文件条目对象的封装

## <img alt="" src="./doc/assets/readme-icon-framework.png" style="display: inline-block;" width=3%/> 架构

图片

### 源码目录

```shell
.
├── doc
├── src
│   ├── upload4cj
│            ├──deferredFile_output_stream.cj
│            ├──disk_file_item_factory.cj
│            ├──disk_file_item.cj
│            ├──file_item_factory.cj
│            ├──file_item_headers_impl.cj
│            ├──file_item_headers_support.cj
│            ├──file_item_headers.cj
│            ├──file_item_iterator_impl.cj
│            ├──file_item_iterator.cj
│            ├──file_item_stream_impl.cj
│            ├──file_item_stream.cj
│            ├──file_item.cj
│            ├──file_upload_base.cj
│            ├──file_upload_exception.cj
│            ├──file_upload.cj
│            ├──inter_input_stream.cj
│            ├──item_input_stream.cj
│            ├──limited_input_stream_impl.cj
│            ├──limited_input_stream.cj
│            ├──mime_utility.cj
│            ├──multipart_stream.cj
│            ├──parameter_parser.cj
│            ├──progress_listener.cj
│            ├──progress_notifier.cj
│            ├──quoted_printable_decoder.cj
│            ├──request_context.cj
│            ├──servlet_file_upload.cj
│            ├──servlet_request_context.cj
│            ├──streams.cj
│            └──thresholding_output_stream.cj
└── test
│   ├── HLT
│   ├── LLT
│   └── UT
├── CHANGELOG.md
├── gitee_gate.cfg
├── LICENSE.txt
├── module.json
├── README.md
├── README.OpenSource
```

- `doc` 存放库的设计文档、使用文档、LLT 用例覆盖报告
- `src` 是库源码目录
- `test` 存放 HLT 测试用例、LLT 自测用例和 UT 单元测试用例

### 接口说明

主要核心类和全局函数说明,详情见 [API](./doc/feature_api.md)

## <img alt="" src="./doc/assets/readme-icon-compile.png" style="display: inline-block;" width=3%/> 使用说明

### 编译

```
cjpm build
```

### 功能示例

#### 解析参数内容的消息头

```cangjie
from upload4cj import upload4cj.*
from std import collection.*

main(){
    let s: String = "test; test1 =  stuff   ; test2 =  \"stuff; stuff\"; test3=\"stuff"
    var parser: ParameterParser = ParameterParser()
    let s1: Option<String> = s
    var map: Map<String, Option<String>> = parser.parse(s1, ';')
    let isTest: Bool = match(map.get("test").getOrThrow()) {
        case None =>
            false
        case Some(v) =>
            true
    }
    if (isTest) {
        return -1
    }
    if (map.get("test1").getOrThrow().getOrThrow() != "stuff") {
        return -2
    }
    if (map.get("test2").getOrThrow().getOrThrow() != "stuff; stuff") {
        return -3
    }
    if (map.get("test3").getOrThrow().getOrThrow() != "\"stuff") {
        return -4
    }
    println("pass")
    return 0
}
```
执行结果如下：

```
pass
```

#### 文件上传请求解析器

```cangjie
from upload4cj import upload4cj.*
from net import http.*
from std import io.*
from std import collection.*

main(){

    let text = "-----1234\r\n" +
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

    let bytes:Array<UInt8> = text.toUtf8Array()
    var output = ByteArrayStream()
    output.write(bytes)
    var req1: Request = Request(RequestMethod.POST, "http://127.0.0.1/", output)
    req1.header.add("Content-Type","multipart/form-data; boundary=---1234")
    let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
    let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)

    if (!mappedParameters.contains("file")) {
        return -1
    }
    if (mappedParameters.get("file").getOrThrow().size != 1) {
        return -2
    }
    if (!mappedParameters.contains("field")) {
        return -3
    }
    if (mappedParameters.get("field").getOrThrow().size != 1) {
        return -4
    }
    if (!mappedParameters.contains("multi")) {
        return -5
    }
    if (mappedParameters.get("multi").getOrThrow().size != 2) {
        return -6
    }

    println("pass")
    return 0
}
```
执行结果如下：

```
pass
```

## 开源协议

```
This code is under the Apache Licence v2. https://www.apache.org/licenses/LICENSE-2.0
```

## <img alt="" src="./doc/assets/readme-icon-contribute.png" style="display: inline-block;" width=3%/>参与贡献

欢迎给我们提交 PR，欢迎给我们提交 issue，欢迎参与任何形式的贡献。

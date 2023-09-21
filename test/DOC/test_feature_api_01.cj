// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from upload4cj import upload4cj.*
from net import http.*
from std import io.*
from std import collection.*
from std import unittest.*
from std import unittest.testmacro.*
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
    func test_featureApi_01 () {
		let text = "-----1234\r\n" +
					  "Content-Disposition: form-data; name=\"file\";                                           filename=\"foo.tab\"\r\n" +
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
		var req1 = HttpRequestBuilder.new().method("POST").url("http://127.0.0.1/").body(output).build()
		req1.headers.add("Content-Type",CONTENT_TYPE)
		let upload:ServletFileUpload = ServletFileUpload(DiskFileItemFactory())
		let mappedParameters: Map<String, ArrayList<FileItem>> = upload.parseParameterMap(req1)

		@Assert(mappedParameters.contains("file"),true)
		@Assert(mappedParameters.get("file").getOrThrow().size,1)
		@Assert(mappedParameters.contains("field"),true)
		@Assert(mappedParameters.get("field").getOrThrow().size,1)
		@Assert(mappedParameters.contains("multi"),true)
		@Assert(mappedParameters.get("multi").getOrThrow().size,2)
    }   
}

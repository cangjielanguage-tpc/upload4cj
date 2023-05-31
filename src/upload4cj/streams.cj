package upload4cj

public class Streams {

    public static func checkFileName(fileName: String): String {

        return fileName;
    }

    public static let  DEFAULT_BUFFER_SIZE:Int64 = 8192

    public static func copy(inputStream:InputStream,outputStream:Option<OutputStream>,closeOutputStream:Bool):Int64{
        return copy(inputStream, outputStream, closeOutputStream,  Array<UInt8>(DEFAULT_BUFFER_SIZE,item:0))
    }

    public static func copy(inputStream:Option<InputStream>,outputStream:Option<OutputStream>,closeOutputStream:Bool,buffer:Array<UInt8>):Int64{
        var output:Option<OutputStream> = outputStream
        var input:Option<InputStream> = inputStream
        try{
            var total = 0
            while(true){
                let res = input.getOrThrow().read(buffer)
                if(res <= 0){
                    break
                }
                if(res > 0){
                    total = total + res
                    if(let Some(i) = output){
                        i.write(buffer.slice(0,res))
                    }
                }
            }

            if(let Some(j) = output){
                if (!closeOutputStream) {
                    j.flush()
                }
                output = Option<OutputStream>.None
            }
            input = Option<InputStream>.None
            return total
        }finally{
            input = Option<InputStream>.None
            output = Option<OutputStream>.None
        }
    }
}

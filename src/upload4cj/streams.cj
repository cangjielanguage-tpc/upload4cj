/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

/**
 * Streams
 */
public class Streams {
    /**
     * DEFAULT_BUFFER_SIZE
     */
    public static let DEFAULT_BUFFER_SIZE: Int64 = 8192

    /**
     * copy the InputStream
     *
     * @param inputStream - Option<InputStream> The InputStream
     * @param outputStream - Option<OutputStream> The OutputStream
     * @param closeOutputStream - Bool close OutputStream or not
     *
     * @return Int64 - The size
     */
    public static func copy(inputStream: Option<InputStream>, outputStream: Option<OutputStream>,
        closeOutputStream: Bool): Int64 {
        return copy(inputStream, outputStream, closeOutputStream, Array<UInt8>(DEFAULT_BUFFER_SIZE, item: 0))
    }

    /**
     * copy the InputStream
     *
     * @param inputStream - Option<InputStream> The InputStream
     * @param outputStream - Option<OutputStream> The OutputStream
     * @param closeOutputStream - Bool close OutputStream or not
     * @param buffer - Array<UInt8> the buffer array
     *
     * @return Int64 - The size
     */
    public static func copy(inputStream: Option<InputStream>, outputStream: Option<OutputStream>,
        closeOutputStream: Bool, buffer: Array<UInt8>): Int64 {
        var output: Option<OutputStream> = outputStream
        var input: Option<InputStream> = inputStream
        try {
            var total = 0
            while (true) {
                let res = input.getOrThrow().read(buffer)
                if (res <= 0) { //原来-1 兼容其他流改<=0
                    break
                }
                if (res > 0) {
                    total += res
                    if (let Some(i) = output) {
                        let bytesRes = buffer.slice(0, res)
                        i.write(bytesRes)
                    }
                }
            }

            if (let Some(j) = output) {
                if (!closeOutputStream) {
                    j.flush()
                }
            }

            let conInput = input as ItemInputStream
            if (let Some(k) = conInput) {
                k.close()
            }
            return total
        } finally {
            input = Option<InputStream>.None
            output = Option<OutputStream>.None
        }
    }

    /**
     * check FileName
     *
     * @param fileName - Option<String> The fileName
     * @return Option<String> - the fileName checked
     */
    public static func checkFileName(fileName: Option<String>): Option<String> {
        if (let Some(i) = fileName) {
            let index: Option<Int64> = i.indexOf('\u{0}')
            if (let Some(_) = index) {
                let sb: StringBuilder = StringBuilder()
                for (k in 0..i.size) {
                    let c: Char = i.get(k).getOrThrow()
                    if (c == '\u{0}') {
                        sb.append("\\0")
                    } else {
                        sb.append(c)
                    }
                }
                throw InvalidFileNameException("Invalid file name: " + sb.toString())
            }
        }
        return fileName
    }
}

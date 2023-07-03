/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package upload4cj

/**
 * FileItemHeadersImpl
 */
public class FileItemHeadersImpl <: FileItemHeaders {
    private let headerNameToValueListMap: Map<String, ArrayList<String>> = HashMap<String, ArrayList<String>>()

    /**
     * get Header
     *
     * @param name - String The header name
     * @return Option<String> - The header
     */
    public override func getHeader(name: String): Option<String> {
        let nameLower: String = name.toAsciiLower()
        let headerValueList: Option<ArrayList<String>> = headerNameToValueListMap.get(nameLower)
        if (let Some(i) = headerValueList) {
            return i.get(0)
        } else {
            return Option<String>.None
        }
    }

    /**
     * get the Header Names Iterator
     *
     * @return Iterator<String> - the Header Names Iterator
     */
    public override func getHeaderNames(): Iterator<String> {
        return headerNameToValueListMap.keys().iterator()
    }

    /**
     * get Headers
     *
     * @param name - String The header name
     * @return Iterator<String> - The header Iterator
     */
    public override func getHeaders(name: String): Iterator<String> {
        let nameLower: String = name.toAsciiLower()
        var headerValueList: Option<ArrayList<String>> = headerNameToValueListMap.get(nameLower)
        if (let Some(i) = headerValueList) {
            return i.iterator()
        } else {
            headerValueList = ArrayList<String>()
            return headerValueList.getOrThrow().iterator()
        }
    }

    /**
     * add Header
     *
     * @param name - String The header name
     * @param value - String The header value
     */
    public func addHeader(name: String, value: String): Unit {
        let nameLower: String = name.toAsciiLower()
        var headerValueList: Option<ArrayList<String>> = headerNameToValueListMap.get(nameLower)
        if (let Some(i) = headerValueList) {}
        else {
            headerValueList = ArrayList<String>()
            headerNameToValueListMap.put(nameLower, headerValueList.getOrThrow())
        }
        headerValueList.getOrThrow().append(value)
    }
}

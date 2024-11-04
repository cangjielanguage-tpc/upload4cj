/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package upload4cj

/**
 * ProgressNotifier
 */
public class ProgressNotifier {
    private let listener: Option<ProgressListener>

    private let contentLength: Int64

    private var bytesRead: Int64 = 0

    private var items: Int64 = 0

    /**
     * init
     *
     * @param pListener - Option<ProgressListener> The ProgressListener
     * @param pContentLength - Int64 The content length
     */
    public init(pListener: Option<ProgressListener>, pContentLength: Int64) {
        listener = pListener
        contentLength = pContentLength
    }

    func noteBytesRead(pBytes: Int64) {
        bytesRead = bytesRead + pBytes
        notifyListener()
    }

    func noteItem(): Unit {
        items++
        notifyListener()
    }

    private func notifyListener() {
        if (let Some(i) <- listener) {
            i.update(bytesRead, contentLength, items)
        }
    }
}

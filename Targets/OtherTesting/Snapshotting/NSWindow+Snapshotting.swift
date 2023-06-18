import AppKit

/// Converts given window numbers into CFArray of CGWindowID's.
func windowArray(_ windowNumbers: [Int]) -> CFArray {
    // https://stackoverflow.com/a/46652374/1859783
    let pointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: windowNumbers.count)
    for (index, windowNumber) in windowNumbers.enumerated() {
        pointer[index] = UnsafeRawPointer(bitPattern: windowNumber)
    }
    return CFArrayCreate(nil, pointer, windowNumbers.count, nil)!
}

extension NSWindow {
    
    func snapshot(options: CGWindowImageOption, timeout: TimeInterval = 1) throws -> NSImage {
        try Self.snapshot(windowNumbers: [windowNumber], imageOptions: options, timeout: timeout)
    }
    
    static func snapshot(windowNumbers: [Int], imageOptions: CGWindowImageOption, timeout: TimeInterval = 5) throws -> NSImage {
        let deadline = Date(timeIntervalSinceNow: timeout)
        let cgImage: CGImage = try {
            var attempts = 0
            repeat {
                attempts += 1
                let cgImage = CGImage(windowListFromArrayScreenBounds: .null, windowArray: windowArray(windowNumbers), imageOption: imageOptions)
                if let cgImage = cgImage {
                    return cgImage
                }
                if deadline < Date() {
                    throw WindowSnapshotError.timedOut(attempts: attempts, timeout: timeout)
                }
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
            } while true
        }()
        
        return NSImage(
            cgImage: cgImage,
            size: .init(
                width: cgImage.width,
                height: cgImage.height
            )
        )
    }
}

enum WindowSnapshotError: Swift.Error {
    case timedOut(attempts: Int, timeout: TimeInterval)
}

extension NSWindow {
    
    static func windowNumbers(listOptions: CGWindowListOption = [], windowNumber: Int) -> [Int] {
        guard !listOptions.isEmpty else {
            return [windowNumber]
        }
        
        let rawWindowInfos = CGWindowListCopyWindowInfo(listOptions, CGWindowID(exactly: windowNumber)!)!
        let windowInfos = rawWindowInfos as! [[CFString: Any]]
        let pid = ProcessInfo().processIdentifier
        return windowInfos
            .filter { info in
                (info[kCGWindowOwnerPID] as! Int) == pid
            }.map { info in
                info[kCGWindowNumber] as! Int
            }
    }
}

import AppKit

extension NSWindow {
    
    func snapshot(options: CGWindowImageOption, timeout: TimeInterval = 1) throws -> NSImage {
        let deadline = Date(timeIntervalSinceNow: timeout)
        let cgImage: CGImage = try {
            var attempts = 0
            repeat {
                attempts += 1
                let cgImage = CGWindowListCreateImage(
                    .null,
                    .optionIncludingWindow,
                    CGWindowID(windowNumber),
                    options
                )
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

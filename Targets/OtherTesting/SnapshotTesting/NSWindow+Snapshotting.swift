import AppKit
import XCTest

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
    
    static func snapshot(windowNumbers: [Int], imageOptions: CGWindowImageOption, timeout: TimeInterval = 1) throws -> NSImage {
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

extension XCTestCase {
    
    func snapshotFlakyBorderWindow(
        window: NSWindow,
        named name: String,
        record: Bool,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        snapshotFlakyBorderWindow(
            windowNumber: window.windowNumber,
            named: name,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }
    
    func snapshotFlakyBorderWindow(
        windowNumber: Int,
        listOptions: CGWindowListOption = .optionIncludingWindow,
        named name: String?,
        record: Bool,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let windowNumbers = NSWindow.windowNumbers(listOptions: listOptions, windowNumber: windowNumber)
        
        let failures: [String] = windowNumbers.compactMap { windowNumber in
            let window = NSApp.window(withWindowNumber: windowNumber)!
            
            return try! verifySnapshot(
                matching: NSWindow.snapshot(windowNumbers: [windowNumber], imageOptions: [.bestResolution, .boundsIgnoreFraming]),
                as: .image(scaleFactor: window.backingScaleFactor),
                named: name,
                record: record,
                file: file,
                testName: testName + ".borderless",
                line: line
            )
        }
        if !failures.isEmpty {
            XCTFail(failures.first!)
        }
        if !failures.isEmpty || ProcessInfo().environment["FORCE_RUN_FLAKY_SNAPSHOTS"] == "YES" {
            let window = NSApp.window(withWindowNumber: windowNumber)!
            try assertSnapshot(
                matching: NSWindow.snapshot(windowNumbers: windowNumbers, imageOptions: [.bestResolution]),
                as: .image(scaleFactor: window.backingScaleFactor),
                named: name,
                record: record,
                file: file,
                testName: testName,
                line: line
            )
        }
    }
}

extension NSWindow {
    
    static func windowNumbers(listOptions: CGWindowListOption = .optionIncludingWindow, windowNumber: Int) -> [Int] {
        let windowInfos = CGWindowListCopyWindowInfo(listOptions, CGWindowID(exactly: windowNumber)!)!
        let pid = ProcessInfo().processIdentifier
        return (windowInfos as! [[CFString: Any]])
            .filter { info in
                (info[kCGWindowOwnerPID] as! Int) == pid
            }.map { info in
                info[kCGWindowNumber] as! Int
            }
    }
}

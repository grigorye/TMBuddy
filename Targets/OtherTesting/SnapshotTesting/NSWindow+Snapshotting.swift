import AppKit
import XCTest

extension NSWindow {
    
    func snapshot(options: CGWindowImageOption, timeout: TimeInterval = 1) throws -> NSImage {
        try Self.snapshot(windowNumber: windowNumber, imageOptions: options, timeout: timeout)
    }
    
    static func snapshot(windowNumber: Int, listOptions: CGWindowListOption = .optionIncludingWindow, imageOptions: CGWindowImageOption, timeout: TimeInterval = 1) throws -> NSImage {
        let deadline = Date(timeIntervalSinceNow: timeout)
        let cgImage: CGImage = try {
            var attempts = 0
            repeat {
                attempts += 1
                let cgImage = CGWindowListCreateImage(
                    .null,
                    listOptions,
                    CGWindowID(windowNumber),
                    imageOptions
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
        let window = NSApp.window(withWindowNumber: windowNumber)!
        let failure = try verifySnapshot(
            matching: NSWindow.snapshot(windowNumber: windowNumber, listOptions: listOptions, imageOptions: [.bestResolution, .boundsIgnoreFraming]),
            as: .image(scaleFactor: window.backingScaleFactor),
            named: name,
            record: record,
            file: file,
            testName: testName + ".borderless",
            line: line
        )
        if let failure = failure {
            XCTFail(failure)
        }
        if failure != nil || ProcessInfo().environment["FORCE_RUN_FLAKY_SNAPSHOTS"] == "YES" {
            try assertSnapshot(
                matching: NSWindow.snapshot(windowNumber: windowNumber, listOptions: listOptions, imageOptions: [.bestResolution]),
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

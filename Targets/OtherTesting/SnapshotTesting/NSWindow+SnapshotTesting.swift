import AppKit
import XCTest

@MainActor
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
        listOptions: CGWindowListOption = [],
        named name: String?,
        record: Bool,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let windowNumbers = NSWindow.windowNumbers(listOptions: listOptions, windowNumber: windowNumber)
        
        assert(!windowNumbers.isEmpty)
        
        let failures: [String] = windowNumbers.compactMap { windowNumber in
            let window = NSApplication.shared.window(withWindowNumber: windowNumber)!
            
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
            XCTFail(failures.first!, file: file, line: line)
        }
        
        let window = NSApplication.shared.window(withWindowNumber: windowNumber)!
        assertSnapshot(
            matching: try NSWindow.snapshot(windowNumbers: windowNumbers, imageOptions: [.bestResolution]),
            as: .image(scaleFactor: window.backingScaleFactor, ignoreDiffs: failures.isEmpty),
            named: name,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }
}

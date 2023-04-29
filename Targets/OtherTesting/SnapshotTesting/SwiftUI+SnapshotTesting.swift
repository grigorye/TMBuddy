import SnapshotTesting
import SwiftUI

@MainActor
func assertSnapshot<View: SwiftUI.View>(
    matching view: View,
    named name: String? = nil,
    record recording: Bool,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let hostingView = NSHostingView(rootView: view)
    let fittingSize = hostingView.fittingSize
    hostingView.bounds.size = fittingSize
    let window = NSWindow(
        contentRect: .init(origin: .zero, size: fittingSize),
        styleMask: .borderless,
        backing: .buffered,
        defer: false,
        screen: .main
    ) … {
        $0.backgroundColor = .clear
        $0.isReleasedWhenClosed = false
    }
    window.contentView = hostingView
    try assertSnapshot(
        matching: NSWindow.snapshot(windowNumbers: [window.windowNumber], imageOptions: [.bestResolution]),
        as: .image(scaleFactor: window.backingScaleFactor),
        named: name,
        record: recording,
        file: file,
        testName: testName,
        line: line
    )
}

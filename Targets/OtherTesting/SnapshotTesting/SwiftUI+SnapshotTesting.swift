import SnapshotTesting
import SwiftUI

func assertSnapshot<View: SwiftUI.View>(
    matching view: View,
    record recording: Bool,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let hostingView = NSHostingView(rootView: view)
    let fittingSize = hostingView.fittingSize
    hostingView.bounds.size = fittingSize
    assertSnapshot(
        matching: hostingView,
        as: .image(size: fittingSize),
        record: recording,
        file: file,
        testName: testName,
        line: line
    )
}

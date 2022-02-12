import XCTest
import SwiftUI
import SnapshotTesting

class MainWindowSnapshots: XCTestCase {
    
    private let record: Bool = false

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let savedEnforcedAppName = enforcedAppName
        enforcedAppName = "TMBuddy"
        addTeardownBlock {
            enforcedAppName = savedEnforcedAppName
        }
        
        let savedEnforcedIsAppDistributedViaAppStore = enforcedIsAppDistributedViaAppStore
        enforcedIsAppDistributedViaAppStore = true
        addTeardownBlock {
            enforcedIsAppDistributedViaAppStore = savedEnforcedIsAppDistributedViaAppStore
        }
    }
    
    func test() {
        for state in AppStateSample.allCases {
            let window = mainWindow(
                contentView: ContentView().appStateSample(state)
            )
            
            window.makeKeyAndOrderFront(nil)
            
            defer {
                window.close()
            }
            
            let failure = try verifySnapshot(
                matching: window.snapshot(options: [.bestResolution, .boundsIgnoreFraming]),
                as: .image,
                named: "\(state).borderless",
                record: record
            )
            if let failure = failure {
                XCTFail(failure)
            }
            if failure != nil || ProcessInfo().environment["FORCE_RUN_FLAKY_SNAPSHOTS"] == "YES" {
                try assertSnapshot(
                    matching: window.snapshot(options: [.bestResolution]),
                    as: .image,
                    named: "\(state)",
                    record: record
                )
            }
        }
    }
}

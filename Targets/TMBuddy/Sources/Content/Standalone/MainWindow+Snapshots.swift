import XCTest
import SwiftUI
import SnapshotTesting

@MainActor
class MainWindowSnapshots: XCTestCase {
    
    private let record: Bool = false

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let savedDefaultEnforcedAppName = defaultEnforcedAppName
        defaultEnforcedAppName = "TMBuddy"
        addTeardownBlock {
            defaultEnforcedAppName = savedDefaultEnforcedAppName
        }
        
        let savedDefaultEnforcedIsAppDistributedViaAppStore = defaultEnforcedIsAppDistributedViaAppStore
        defaultEnforcedIsAppDistributedViaAppStore = true
        addTeardownBlock {
            defaultEnforcedIsAppDistributedViaAppStore = savedDefaultEnforcedIsAppDistributedViaAppStore
        }
    }
    
    func test() {
        for state in AppStateSample.allCases {
            let contentView = mainWindowContentView()
                .appStateSample(state)
                .fixedSize()
            
            let window = mainWindow(contentView: contentView)
            window.makeKeyAndOrderFront(nil)
            
            defer {
                window.close()
            }

            snapshotFlakyBorderWindow(
                window: window,
                named: "\(state)",
                record: record
            )
        }
    }
}

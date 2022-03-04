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

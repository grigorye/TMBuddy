import XCTest
import SwiftUI

@MainActor
class SandboxAccessSnapshots: XCTestCase {
    
    private let record: Bool = false
    
    func test() throws {
        try XCTSkipIf(true)
        snapshotSamples(
            SMJobBlessCheckpointView.self,
            PlugInFullDiskAccessCheckpointView.self,
            FinderSyncExtensionCheckpointView.self,
            FolderSelectionCheckpointView.self,
            record: record
        ) {
            ContentView()
        }
    }
    
    func testBuddyGreen() {
        let view = mainWindowContentView()
            .appStateSample(.allGreen)
        assertSnapshot(matching: view, record: record)
    }
}

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
            ContentView.new()
        }
    }
    
    func testBuddyGreenSetup() {
        let view = mainWindowContentView()
            .appStateSample(.init(allGreen: true, tab: .setup))
        assertSnapshot(matching: view, record: record)
    }
    
    func testBuddyGreenFolders() {
        let view = mainWindowContentView()
            .appStateSample(.init(allGreen: true, tab: .folders))
        assertSnapshot(matching: view, record: record)
    }
}

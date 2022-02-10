import XCTest
import SwiftUI
import SnapshotTesting

extension SMJobBlessCheckpointView {
    init() {
        self.init(checkpointProvider: .init(), actions: nil)
    }
}

extension PostInstallHelperCheckpointView {
    init() {
        self.init(checkpointProvider: .init(), blessCheckpointProvider: .init(), actions: nil)
    }
}

class TMBuddySnapshots: XCTestCase {
    
    private let record: Bool = false

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let savedEnforcedAppName = enforcedAppName
        enforcedAppName = "TMBuddy"
        addTeardownBlock {
            enforcedAppName = savedEnforcedAppName
        }
        
        let savedEnforcedBuildInfoString = enforcedBuildInfoString
        enforcedBuildInfoString = "1"
        addTeardownBlock {
            enforcedBuildInfoString = savedEnforcedBuildInfoString
        }
    }
    
    func testSMJobBlessCheckpointView() throws {
        let view = SMJobBlessCheckpointView()
            .border(.red)
            .environmentObject(
                StateHolder<SMJobBlessCheckpointState>() ≈ {
                    $0.state = .blessed
                }
            )
        assertSnapshot(matching: view, record: record)
    }
    
    func testSandboxAccessView() throws {
        let view = SandboxAccessView()
            .border(.red)
            .environmentObject(
                StateHolder<SMJobBlessCheckpointState>() ≈ {
                    $0.state = .blessed
                }
            )
        assertSnapshot(matching: view, record: record)
    }
    
    func testContentView() throws {
        let view = ContentView()
            .border(.red)
            .environmentObject(
                StateHolder<SMJobBlessCheckpointState>() ≈ {
                    $0.state = .blessed
                }
            )
        assertSnapshot(matching: view, record: record)
    }
    
    func testMainWindowContentView() throws {
        let window = mainWindow()
        let view = window.contentView!
        
        assertSnapshot(matching: view, as: .image, record: record)
    }

    func testMainWindow(options: CGWindowImageOption = .bestResolution, record: Bool, testName: String = #function) throws {
        let window = mainWindow()
        
        window.makeKeyAndOrderFront(nil)
        defer {
            window.close()
        }
        
        try assertSnapshot(
            matching: window.snapshot(options: options),
            as: .image,
            record: record,
            testName: testName
        )
    }
    
    func testMainWindowWithoutShadows() throws {
        try testMainWindow(options: [.bestResolution, .boundsIgnoreFraming], record: record)
    }

    func testMainWindow() throws {
        try XCTSkipUnless(ProcessInfo.processInfo.environment["SNAPSHOT_SHADOWS"] == "YES")
        try testMainWindow(options: [.bestResolution], record: record)
    }
}

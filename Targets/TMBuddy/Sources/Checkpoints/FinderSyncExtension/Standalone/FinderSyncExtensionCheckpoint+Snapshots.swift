import XCTest

class FinderSyncExtensionCheckpointSnapshots: XCTestCase {
    
    private let record: Bool = false

    func test() throws {
        FinderSyncExtensionCheckpointView.snapshotSamples(record: record)
    }
}

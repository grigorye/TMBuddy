import XCTest

class SMJobBlessCheckpointSnapshots: XCTestCase {
    
    private let record: Bool = false

    func test() throws {
        SMJobBlessCheckpointView.snapshotSamples(record: record)
    }
}

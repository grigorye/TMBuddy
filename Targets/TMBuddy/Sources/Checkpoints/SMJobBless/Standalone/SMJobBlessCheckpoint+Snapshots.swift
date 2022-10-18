import XCTest

class SMJobBlessCheckpointSnapshots: XCTestCase {
    
    private let record: Bool = false
    
    func test() async throws {
        await SMJobBlessCheckpointView
            .snapshotSamples(
                frameWidth: sampleCheckpointWidth,
                record: record
            )
    }
}

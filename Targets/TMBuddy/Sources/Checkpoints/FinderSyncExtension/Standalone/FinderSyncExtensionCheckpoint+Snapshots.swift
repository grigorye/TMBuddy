import XCTest

class FinderSyncExtensionCheckpointSnapshots: XCTestCase {
    
    private let record: Bool = false

    func test() async throws {
        await FinderSyncExtensionCheckpointView
            .snapshotSamples(
                frameWidth: sampleCheckpointWidth,
                record: record
            )
    }
}

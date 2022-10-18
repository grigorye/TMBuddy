import XCTest

class FolderSelectionCheckpointSnapshots: XCTestCase {
    
    private let record: Bool = false

    func test() async throws {
        await FolderSelectionCheckpointView
            .snapshotSamples(
                frameWidth: sampleCheckpointWidth,
                record: record
            )
    }
}

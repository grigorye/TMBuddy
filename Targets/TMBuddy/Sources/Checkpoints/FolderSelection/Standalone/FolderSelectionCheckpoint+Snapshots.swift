import XCTest

class FolderSelectionCheckpointSnapshots: XCTestCase {
    
    private let record: Bool = false

    func test() throws {
        FolderSelectionCheckpointView
            .snapshotSamples(
                frameWidth: sampleCheckpointWidth,
                record: record
            )
    }
}

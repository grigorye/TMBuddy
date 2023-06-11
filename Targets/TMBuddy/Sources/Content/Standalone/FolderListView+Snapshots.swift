import XCTest

class FolderListViewSnapshots: XCTestCase {
    
    private let record: Bool = false

    func test() async throws {
        await FolderListView
            .snapshotSamples(
                frameWidth: sampleCheckpointWidth,
                record: record
            )
    }
}

import XCTest

class PlugInFullDiskAccessCheckpointSnapshots: XCTestCase {
    
    private let record: Bool = false

    func test() async throws {
        await PlugInFullDiskAccessCheckpointView
            .snapshotSamples(
                frameWidth: sampleCheckpointWidth,
                record: record
            )
    }
}

import XCTest

class PlugInFullDiskAccessCheckpointSnapshots: XCTestCase {
    
    private let record: Bool = false

    func test() throws {
        PlugInFullDiskAccessCheckpointView
            .snapshotSamples(
                frameWidth: sampleCheckpointWidth,
                record: record
            )
    }
}

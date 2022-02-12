import XCTest

class PlugInFullDiskAccessCheckpointSnapshots: XCTestCase {
    
    private let record: Bool = false

    func test() throws {
        PlugInFullDiskAccessCheckpointView.snapshotSamples(record: record)
    }
}

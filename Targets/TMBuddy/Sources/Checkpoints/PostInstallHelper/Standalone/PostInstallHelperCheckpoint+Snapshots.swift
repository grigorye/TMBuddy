import XCTest

class PostInstallHelperCheckpointSnapshots: XCTestCase {
    
    private let record: Bool = false

    func test() throws {
        PostInstallHelperCheckpointView
            .snapshotSamples(
                frameWidth: sampleCheckpointWidth,
                record: record
            )
    }
}

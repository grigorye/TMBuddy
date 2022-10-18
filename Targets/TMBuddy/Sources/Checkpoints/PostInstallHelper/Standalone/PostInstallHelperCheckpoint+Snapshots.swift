import XCTest

class PostInstallHelperCheckpointSnapshots: XCTestCase {
    
    private let record: Bool = false

    func test() async throws {
        await PostInstallHelperCheckpointView
            .snapshotSamples(
                frameWidth: sampleCheckpointWidth,
                record: record
            )
    }
}

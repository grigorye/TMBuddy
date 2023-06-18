@testable import TMBuddySnapshotViews
@testable import func SnapshotTesting.sanitizePathComponent
import XCTest

final class MainWindowSnapshots: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test() throws {
        let app = XCUIApplication()
        
        for state in AppStateSample.allCases {
            let snapshotBasePath = snapshotDirectory(forFile: #file) + "/" + sanitizePathComponent(#function) + ".\(state.sampleName)"
            let appStateSampleJsonBase64 = try! JSONEncoder().encode(state).base64EncodedString()
            app.launchArguments = [
                "-appStateSampleJsonBase64", appStateSampleJsonBase64,
                "-snapshotBasePath", snapshotBasePath
            ]
            app.launch()
            Thread.sleep(forTimeInterval: 1)
        }
    }
}

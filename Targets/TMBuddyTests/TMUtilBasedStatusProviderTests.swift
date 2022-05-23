import XCTest
import Foundation

class TMUtilBasedStatusProviderTests: XCTestCase {
    
    var provider: TMUtilBasedStatusProvider { .init() }
    
    func testNonMainDiskIsExcluded() throws {
        let url = excludedVolumeURL
        try XCTSkipUnless(url.checkResourceIsReachable())
        let status = try provider.statusForItem(url)
        if NSUserName().contains("-runner") {
            XCTAssertEqual(status, .unknown)
        } else {
            XCTAssertEqual(status, .parentExcluded)
        }
    }
    
    func testTmpIsExcluded() throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: "/tmp"))
        XCTAssertEqual(status, .parentExcluded)
    }
}

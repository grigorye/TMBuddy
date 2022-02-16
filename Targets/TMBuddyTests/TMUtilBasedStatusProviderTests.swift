import XCTest

class TMUtilBasedStatusProviderTests: XCTestCase {
    
    var provider: TMUtilBasedStatusProvider { .init() }
    
    func testNonMainDiskIsExcluded() async throws {
        let url = excludedVolumeURL
        try XCTSkipUnless(url.checkResourceIsReachable())
        let status = try provider.statusForItem(url)
        XCTAssertEqual(status, .parentExcluded)
    }
    
    func testTmpIsExcluded() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: "/tmp"))
        XCTAssertEqual(status, .parentExcluded)
    }
}

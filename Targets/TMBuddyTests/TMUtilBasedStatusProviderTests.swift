import XCTest

class TMUtilBasedStatusProviderTests: XCTestCase {
    
    var provider: TMUtilBasedStatusProvider { .init() }
    
    func testNonMainDiskIsExcluded() throws {
        let url = excludedVolumeURL
        try XCTSkipUnless(url.checkResourceIsReachable())
        let status = try provider.statusForItem(url)
        XCTAssertEqual(status, .parentExcluded)
    }
    
    func testTmpIsExcluded() throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: "/tmp"))
        XCTAssertEqual(status, .parentExcluded)
    }
}

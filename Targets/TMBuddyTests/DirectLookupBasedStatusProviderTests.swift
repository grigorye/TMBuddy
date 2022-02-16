import XCTest

class DirectLookupBasedStatusProviderTests: XCTestCase {
    
    var provider: DirectLookupBasedStatusProvider { .init() }
    
    func testExcludedBasedOnMetadata() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: NSHomeDirectory() + "/TMBuddyTest/stickyExcluded"))
        XCTAssertEqual(status, .stickyExcluded)
    }
    
    func testExcludedBasedOnParentMetadata() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: NSHomeDirectory() + "/TMBuddyTest/stickyExcluded/parentExcluded"))
        XCTAssertEqual(status, .parentExcluded)
    }
    
    func testExcludedBasedOnPath() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: "/Applications"))
        XCTAssertEqual(status, .pathExcluded)
    }
    
    func testExcludedVolume() async throws {
        let url = excludedVolumeURL
        try XCTSkipUnless(url.checkResourceIsReachable())
        let status = try provider.statusForItem(url)
        XCTAssertEqual(status, .parentExcluded)
    }
    
    func testExcludedOnParentVolume() async throws {
        try XCTSkipUnless(excludedVolumeURL.checkResourceIsReachable())
        let url = excludedVolumeURL.appendingPathComponent("TMBuddyTest")
        let status = try provider.statusForItem(url)
        XCTAssertEqual(status, .parentExcluded)
    }

    func testIncluded() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: NSHomeDirectory()))
        XCTAssertEqual(status, .included)
    }
}

import XCTest

class TimeMachineVolumeFilterTests: XCTestCase {
    
    func testNonMainDiskIsExcluded() async throws {
        let url = excludedVolumeURL
        try XCTSkipUnless(url.checkResourceIsReachable())
        let filter = TimeMachineVolumeFilter()
        let isExcluded = filter.isExcluded(url)
        XCTAssertEqual(isExcluded, true)
    }
}

extension XCTestCase {
    
    var excludedVolumeURL: URL {
        URL(fileURLWithPath: "/Volumes/.TMBuddy-Excluded")
    }
}

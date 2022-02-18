import XCTest

class TimeMachinePathFilterTests: XCTestCase {
    
    var filter: TimeMachinePathFilter { .init() }
    
    func testIsExcluded() async throws {
        try XCTSkipUnless(excludedByPathURL.checkResourceIsReachable())
        let isExcluded = filter.isExcluded(excludedByPathURL)
        XCTAssertTrue(isExcluded)
    }
    
    func testIsIncluded() async throws {
        let isExcluded = filter.isExcluded(nonExcludedURL)
        XCTAssertFalse(isExcluded)
    }
}

extension XCTestCase {
    
    var nonExcludedURL: URL {
        FileManager.default.homeDirectoryForCurrentUser
    }
    
    var excludedByPathURL: URL {
        URL(fileURLWithPath: "/Volumes/.TMBuddy-Included/Excluded-By-Path")
    }
}

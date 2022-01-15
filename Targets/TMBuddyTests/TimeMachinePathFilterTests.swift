import XCTest

class TimeMachinePathFilterTests: XCTestCase {
    
    var filter: TimeMachinePathFilter { .init() }
    
    func testIsExcluded() async throws {
        let isExcluded = filter.isExcluded(URL(fileURLWithPath: "/Applications"))
        XCTAssertTrue(isExcluded)
    }
    
    func testIsIncluded() async throws {
        let isExcluded = filter.isExcluded(URL(fileURLWithPath: NSHomeDirectory()))
        XCTAssertFalse(isExcluded)
    }
}

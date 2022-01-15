import XCTest

class TimeMachineVolumeFilterTests: XCTestCase {
    
    func testNonMainDiskIsExcluded() async throws {
        let url = URL(fileURLWithPath: "/Volumes/Ginger")
        let filter = TimeMachineVolumeFilter()
        let isExcluded = try filter.isExcluded(url)
        XCTAssertEqual(isExcluded, true)
    }
}

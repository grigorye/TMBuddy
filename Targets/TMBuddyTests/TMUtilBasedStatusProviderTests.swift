import XCTest

class TMUtilBasedStatusProviderTests: XCTestCase {
    
    var provider: TMUtilBasedStatusProvider { .init() }
    
    func testNonMainDiskIsExcluded() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: "/Volumes/Ginger"))
        XCTAssertEqual(status, .excluded)
    }
    
    func testTmpIsExcluded() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: "/tmp"))
        XCTAssertEqual(status, .excluded)
    }
}

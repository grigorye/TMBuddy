import XCTest

class DirectLookupBasedStatusProviderTests: XCTestCase {
    
    var provider: DirectLookupBasedStatusProvider { .init() }
    
    func testExcludedBasedOnMetadata() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: "/Library/CoreAnalytics"))
        XCTAssertEqual(status, .parentExcluded)
    }
    
    func testExcludedBasedOnParentMetadata() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: NSHomeDirectory() + "/Library/Suggestions/training.db"))
        XCTAssertEqual(status, .parentExcluded)
    }
    
    func testExcludedBasedOnPath() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: "/Applications"))
        XCTAssertEqual(status, .pathExcluded)
    }
    
    func testExcludedBasedOnVolume() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: "/Volumes/Ginger"))
        XCTAssertEqual(status, .parentExcluded)
    }
    
    func testExcludedBasedOnParentVolume() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: "/Volumes/Ginger/Library"))
        XCTAssertEqual(status, .parentExcluded)
    }

    func testIncluded() async throws {
        let status = try provider.statusForItem(URL(fileURLWithPath: NSHomeDirectory()))
        XCTAssertEqual(status, .included)
    }
}

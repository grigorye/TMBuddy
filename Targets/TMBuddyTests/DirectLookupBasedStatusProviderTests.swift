import XCTest

class DirectLookupBasedStatusProviderTests: XCTestCase {
    
    var provider: DirectLookupBasedStatusProvider { .init() }
    
    func testExcludedBasedOnMetadata() async throws {
        let status = try await provider.statusForItem(URL(fileURLWithPath: "/Library/CoreAnalytics"))
        XCTAssertEqual(status, .excluded)
    }
    
    func testExcludedBasedOnParentMetadata() async throws {
        let status = try await provider.statusForItem(URL(fileURLWithPath: NSHomeDirectory() + "/Library/Suggestions/training.db"))
        XCTAssertEqual(status, .excluded)
    }
    
    func testExcludedBasedOnPath() async throws {
        let status = try await provider.statusForItem(URL(fileURLWithPath: "/Applications"))
        XCTAssertEqual(status, .excluded)
    }
    
    func testExcludedBasedOnVolume() async throws {
        let status = try await provider.statusForItem(URL(fileURLWithPath: "/Volumes/Ginger"))
        XCTAssertEqual(status, .excluded)
    }
    
    func testExcludedBasedOnParentVolume() async throws {
        let status = try await provider.statusForItem(URL(fileURLWithPath: "/Volumes/Ginger/Library"))
        XCTAssertEqual(status, .excluded)
    }

    func testIncluded() async throws {
        let status = try await provider.statusForItem(URL(fileURLWithPath: NSHomeDirectory()))
        XCTAssertEqual(status, .included)
    }
}

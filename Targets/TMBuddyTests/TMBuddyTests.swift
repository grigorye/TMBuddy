import XCTest

class TMBuddyTests: XCTestCase {

    func testExample() throws {
        let dataURL = Bundle(for: Self.self).url(forResource: "TmUtilIsExcludedOutput", withExtension: "txt")!
        let data = try Data(contentsOf: dataURL)
        let responses = try PropertyListDecoder().decode([PlutilIsExcludedResponse].self, from: data)
        XCTAssertGreaterThan(responses.count, 0)
    }
    
    func testStatus() async throws {
        let status = try await TMStatusProvider().statusForItem(URL(fileURLWithPath: "/tmp"))
        XCTAssertEqual(status, .excluded)
    }
    
    func testExclusion() async throws {
        dump(Bundle.main)
        try await TMUtilLauncher().addExclusion(urls: [URL(fileURLWithPath: "/tmp")])
    }
}

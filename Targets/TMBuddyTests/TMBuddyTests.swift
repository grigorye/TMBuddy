import XCTest

class TMBuddyTests: XCTestCase {

    func testExample() throws {
        let dataURL = Bundle(for: Self.self).url(forResource: "TmUtilIsExcludedOutput", withExtension: "txt")!
        let data = try Data(contentsOf: dataURL)
        let responses = try PropertyListDecoder().decode([PlutilIsExcludedResponse].self, from: data)
        XCTAssertGreaterThan(responses.count, 0)
    }
    
    func testExclusion() throws {
        dump(Bundle.main, name: "bundle")
        try TMUtilLauncher().setExcluded(true, urls: [URL(fileURLWithPath: "/tmp")])
    }
}

import XCTest

class DirectLookupBasedStatusProviderTests: XCTestCase {
    
    var provider: DirectLookupBasedStatusProvider { .init() }
    
    let metadataWriter: MetadataWriter = ExtendedAttributesBackupController()
    
    var testDirectory: URL!
    var stickyExcludedDirectory: URL!
    var stickyExcludedDirectoryChild: URL!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let fileManager = FileManager.default
        testDirectory = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        stickyExcludedDirectory = testDirectory.appendingPathComponent("StickyExcluded")
        stickyExcludedDirectoryChild = stickyExcludedDirectory.appendingPathComponent("Child")
        try fileManager.createDirectory(at: stickyExcludedDirectoryChild, withIntermediateDirectories: true, attributes: nil)
        addTeardownBlock { [testDirectory = testDirectory!] in
            try! fileManager.removeItem(at: testDirectory)
        }
        
        try metadataWriter.setExcluded(true, urls: [stickyExcludedDirectory])
    }
    
    func testExcludedBasedOnMetadata() async throws {
        let status = try provider.statusForItem(stickyExcludedDirectory)
        XCTAssertEqual(status, .stickyExcluded)
    }
    
    func testExcludedBasedOnParentMetadata() async throws {
        let status = try provider.statusForItem(stickyExcludedDirectoryChild)
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

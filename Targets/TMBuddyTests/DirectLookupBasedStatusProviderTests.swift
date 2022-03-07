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
    
    // MARK: -
    
    func testIncluded() {
        let url = nonExcludedURL
        let status = provider.statusForItem(url)
        XCTAssertEqual(status, .included)
    }
    
    func testExcludedBasedOnMetadata() {
        let status = provider.statusForItem(stickyExcludedDirectory)
        XCTAssertEqual(status, .stickyExcluded)
    }
    
    func testExcludedBasedOnParentMetadata() {
        let status = provider.statusForItem(stickyExcludedDirectoryChild)
        XCTAssertEqual(status, .parentExcluded)
    }
    
    // MARK: -
    
    func testExcludedBasedOnPath() throws {
        let url = excludedByPathURL
        try XCTSkipUnless(url.checkResourceIsReachable())
        let status = provider.statusForItem(url)
        XCTAssertEqual(status, .pathExcluded)
    }
    
    func testExcludedVolume() throws {
        let url = excludedVolumeURL
        try XCTSkipUnless(url.checkResourceIsReachable())
        let status = provider.statusForItem(url)
        XCTAssertEqual(status, .excludedVolume)
    }
    
    func testExcludedOnParentVolume() throws {
        let url = excludedByParentVolumeURL
        try XCTSkipUnless(url.checkResourceIsReachable())
        let status = provider.statusForItem(url)
        XCTAssertEqual(status, .parentExcluded)
    }
}

extension XCTestCase {
    
    var excludedByParentVolumeURL: URL {
        excludedVolumeURL.appendingPathComponent("Excluded-By-Parent-Volume")
    }
}

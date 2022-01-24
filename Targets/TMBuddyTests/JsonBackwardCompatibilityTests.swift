import XCTest

private struct FinderSyncInfoRequestV1: Codable {
    var version: String
    var command: Command
    
    enum Command: Codable, Equatable {
        case checkStatus
    }
}

private struct FinderSyncInfoRequestV2: Codable {
    var version: String
    var command: Command
    
    enum Command: Codable, Equatable {
        case checkStatus
        case newCommand([String: String])
    }
}

class PayloadBackwardCompatibilityTests: XCTestCase {

    func testCompatible() throws {
        let v2 = FinderSyncInfoRequestV2(version: "2", command: .checkStatus)
        let data = try PropertyListEncoder().encode(v2)
        let v1 = try PropertyListDecoder().decode(FinderSyncInfoRequestV1.self, from: data)
        XCTAssertEqual(v1.command, .checkStatus)
    }
    
    func testIncompatible() throws {
        let v2 = FinderSyncInfoRequestV2(version: "2", command: .newCommand(["x": "y"]))
        let data = try PropertyListEncoder().encode(v2)
        XCTAssertThrowsError(try PropertyListDecoder().decode(FinderSyncInfoRequestV1.self, from: data))
    }
}

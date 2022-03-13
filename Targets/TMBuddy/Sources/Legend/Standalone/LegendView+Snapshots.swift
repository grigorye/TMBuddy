import XCTest
import SwiftUI

class LegendViewSnapshots: XCTestCase {
    
    private let record: Bool = false
    
    func test() throws {
        assertSnapshot(
            matching: LegendView(state: .init(), actions: nil),
            record: record
        )
    }
}

import XCTest
import SwiftUI

class LegendViewSnapshots: XCTestCase {
    
    private let record: Bool = false
    
    func test() async throws {
        await assertSnapshot(
            matching: LegendView(state: .init(), actions: nil),
            record: record
        )
    }
}

import SwiftUI
@testable import TMBuddySnapshotViews
import Accessibility

@available(macOS 13.0, *)
@main
struct TMBuddySnapshotHostApp: App {
    
    @AppStorage("appStateSampleJsonBase64") var appStateSampleJsonBase64: String?
    
    var appStateSample: AppStateSample {
        guard let appStateSampleJsonBase64 else {
            return .init(allGreen: true, tab: .setup)
        }
        return try! JSONDecoder().decode(AppStateSample.self, from: Data(base64Encoded: appStateSampleJsonBase64)!)
    }

    var body: some Scene {
        WindowGroup {
            mainWindowContentView().fixedSize()
                .appStateSample(appStateSample)
                .snapshottingUITestWindow()
        }
        .windowResizability(.contentSize)
    }
}

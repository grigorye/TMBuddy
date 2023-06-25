import SwiftUI
@testable import TMBuddySnapshotViews
import Accessibility

@available(macOS 13.0, *)
@main
struct TMBuddySnapshotHostApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate

    @AppStorage("appStateSampleJsonBase64") var appStateSampleJsonBase64: String?
    
    var appStateSample: AppStateSample {
        guard let appStateSampleJsonBase64 else {
            return .init(allGreen: true, tab: .setup)
        }
        return try! JSONDecoder().decode(AppStateSample.self, from: Data(base64Encoded: appStateSampleJsonBase64)!)
    }

    var body: some Scene {
        mainScene {
            mainWindowContentView()
                .appStateSample(appStateSample)
                .snapshottingUITestWindow()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        openSettings()
    }
}

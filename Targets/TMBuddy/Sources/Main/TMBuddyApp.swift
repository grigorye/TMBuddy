import SwiftUI

@available(macOS 11.0, *)
@main
struct TMBuddyApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        mainScene {
            mainWindowContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        dump(Bundle.main.bundlePath, name: "bundlePath")
        onLaunch()
        applicationLoadActivity = beginActivity((), name: "applicationLoad")
        openSettings()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        dump(Bundle.main.bundlePath, name: "bundlePath")
    }
}

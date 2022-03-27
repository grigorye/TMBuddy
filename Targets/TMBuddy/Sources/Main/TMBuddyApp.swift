import SwiftUI

@available(macOS 11.0, *)
struct TMBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            mainWindowContentView().fixedSize()
        }
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        dump(Bundle.main.bundlePath, name: "bundlePath")
        onLaunch()
        applicationLoadActivity = beginActivity((), name: "applicationLoad")
        mainWindow().makeKeyAndOrderFront(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        dump(Bundle.main.bundlePath, name: "bundlePath")
    }
}

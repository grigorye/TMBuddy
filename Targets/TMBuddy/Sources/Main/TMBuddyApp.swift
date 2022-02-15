import SwiftUI

@available(macOS 11.0, *)
struct TMBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        dump(Bundle.main.bundlePath, name: "bundlePath")
        onLaunch()
        mainWindow().makeKeyAndOrderFront(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        dump(Bundle.main.bundlePath, name: "bundlePath")
    }
}

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
        onLaunch()
        mainWindow().makeKeyAndOrderFront(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
}

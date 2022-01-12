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
        let contentView = ContentView()
        
        let window = NSWindow(
            contentRect: .init(origin: .zero, size: .init(width: 320, height: 480)),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        ) ≈ {
            $0.title = appName
            $0.isReleasedWhenClosed = false
            $0.center()
            $0.contentView = NSHostingView(rootView: contentView)
        }
        
        window.makeKeyAndOrderFront(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
}

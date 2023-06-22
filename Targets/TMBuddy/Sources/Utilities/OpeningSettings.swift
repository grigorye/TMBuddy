import AppKit
import Foundation

@MainActor
func openSettings() {
    if #available(macOS 13, *) {
        app.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    } else {
        app.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
    }
    app.activate(ignoringOtherApps: true)
    app.sendAction(#selector(NSWindow.orderFrontRegardless), to: nil, from: nil)
}

#if !IMP
@MainActor
let app = NSApp!
#endif

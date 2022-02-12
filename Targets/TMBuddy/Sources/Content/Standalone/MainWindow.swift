import AppKit
import SwiftUI

func mainWindow() -> NSWindow {
    mainWindow(contentView: ContentView())
}

func mainWindow<ContentView: View>(contentView: ContentView) -> NSWindow {
    NSWindow(
        contentRect: .init(origin: .zero, size: .init(width: 320, height: 480)),
        styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
        backing: .buffered,
        defer: false
    ) ≈ {
        $0.title = mainWindowTitle()
        $0.isReleasedWhenClosed = false
        $0.center()
        $0.contentView = NSHostingView(rootView: contentView)
    }
}

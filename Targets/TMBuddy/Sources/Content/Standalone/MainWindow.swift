import AppKit
import SwiftUI

func mainWindowContentView() -> some View {
    ContentView()
        .fixedSize()
}

func mainWindow() -> NSWindow {
    mainWindow(contentView: mainWindowContentView())
}

func mainWindow<ContentView: View>(contentView: ContentView) -> NSWindow {
    NSWindow(
        contentRect: .init(origin: .zero, size: .init(width: 100, height: 100)),
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

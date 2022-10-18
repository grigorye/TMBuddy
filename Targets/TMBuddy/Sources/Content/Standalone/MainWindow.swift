import AppKit
import SwiftUI

@MainActor
func mainWindowContentView() -> some View {
    ContentView()
        .fixedSize()
        .onAppear {
            applicationLoadActivity?.end(())
        }
}

@MainActor
func mainWindow() -> NSWindow {
    mainWindow(contentView: mainWindowContentView())
}

@MainActor
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

@MainActor var applicationLoadActivity: TrackedActivity?

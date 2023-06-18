import SwiftUI
import AppKit

extension View {
    func snapshottingUITestWindow() -> some View {
        self
            .background(SnapshottingView())
    }
}

private struct SnapshottingView: NSViewRepresentable {
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 /* allow window to become key one */) {
            snapshot(window: view.window)
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        snapshot(window: nsView.window)
    }
    
    @MainActor
    func snapshot(window: NSWindow?) {
        guard let window = window else { return }
        let snapshotBaseURL = URL(fileURLWithPath: UserDefaults.standard.string(forKey: "snapshotBasePath")!)
        snapshotFlakyBorderWindow(window: window, snapshotBaseURL: snapshotBaseURL)
    }
}

import SwiftUI

struct FullDiskAccessCheckpointView: View {
    var body: some View {
        let isFullDiskAccessGranted = isFullDiskAccessGranted()
        
        CheckpointView(
            title: "Time Machine settings",
            subtitle: "\(appName) reads the list of items excluded from backup from Time Machine settings.",
            value: isFullDiskAccessGranted ? "access granted" : "access denied",
            readiness: isFullDiskAccessGranted ? .ready : .blocked
        ) {
            HStack {
                Button("Full Disk Access Settings") {
                    NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!)
                }
                Button("Reveal \(appName) in \(finderName)") {
                    NSWorkspace.shared.activateFileViewerSelecting([Bundle.main.bundleURL])
                }
            }
        }
    }
}

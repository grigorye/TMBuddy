import SwiftUI

struct PlugInFullDiskAccessCheckPointView: View {
    
    @ObservedObject var checkpointProvider = PlugInFullDiskAccessCheckPointProvider()
    @ObservedObject var extensionStatusProvider = FinderSyncExtensionStatusProvider()

    var body: some View {
        let isFullDiskAccessGranted = checkpointProvider.accessGranted
        
        let checkpointValue: String = {
            switch isFullDiskAccessGranted {
            case .none:
                return extensionStatusProvider.isEnabled
                ? "checking..."
                : "access unknown as extension is disabled."
            case .some(true):
                return "access granted"
            case .some(false):
                return "access denied"
            }
        }()
        
        CheckpointView(
            title: "Time Machine settings",
            subtitle: "\(appName) reads the list of paths excluded from backup from Time Machine settings.",
            value: checkpointValue,
            completed: isFullDiskAccessGranted == true
        ) {
            VStack(alignment: .leading) {
                Button("Reveal Extension in \(finderName)") {
                    NSWorkspace.shared.activateFileViewerSelecting([plugInURL!])
                }
                Button("Full Disk Access Settings") {
                    NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!)
                }
                let nl="\n"
                Text("To grant \(appName) access to Time Machine settings, please unlock Full Disk Access Settings\(nl)and then drop \(plugInName) into the list of apps with allowed access.")
                    .font(.footnote)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

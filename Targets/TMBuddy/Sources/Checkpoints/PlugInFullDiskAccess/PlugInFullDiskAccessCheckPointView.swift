import SwiftUI

struct PlugInFullDiskAccessCheckPointView: View {
    
    @ObservedObject var checkpointProvider = PlugInFullDiskAccessCheckPointProvider()
    @ObservedObject var extensionStatusProvider = FinderSyncExtensionStatusProvider()

    var body: some View {
        let isFullDiskAccessGranted = checkpointProvider.accessGranted
        
        let checkpointValue: String = {
            switch isFullDiskAccessGranted {
            case .none:
                return "checking..."
            case .unresponsive:
                let extensionStatus = extensionStatusProvider.extensionStatus
                switch (extensionStatus.enabled, extensionStatus.alienInfo) {
                case (.some(true), .same):
                    return "not yet connected"
                case (.some(true), .alien):
                    return "alien"
                case (.some(true), .failing):
                    return "failing"
                case (.some(true), nil):
                    return "unresponsive"
                case (nil, _):
                    return "unknown"
                case (.some(false), _):
                    return "unknown (enable the extension)"
                }
            case .granted:
                return "granted"
            case .denied:
                return "denied"
            }
        }()
        
        CheckpointView(
            title: "Time Machine settings access",
            subtitle: "\(appName) reads the list of paths excluded from backup from Time Machine settings.",
            value: checkpointValue,
            completed: isFullDiskAccessGranted == .granted
        ) {
            VStack(alignment: .leading) {
                HStack {
                    Button("Reveal Extension in \(finderName)") {
                        NSWorkspace.shared.activateFileViewerSelecting([plugInURL!])
                    }
                    Button("Full Disk Access Preferences") {
                        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!)
                    }
                }
                let nl="\n"
                Text("To grant \(appName) access to Time Machine settings, please unlock Full Disk Access preferences\(nl)and then drop \(plugInName) into the list of apps with allowed access.")
                    .font(.footnote)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

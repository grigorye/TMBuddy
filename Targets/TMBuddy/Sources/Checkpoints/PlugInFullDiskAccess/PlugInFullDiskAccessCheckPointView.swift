import SwiftUI

struct PlugInFullDiskAccessCheckPointView: View {
    
    @ObservedObject var checkpointProvider = PlugInFullDiskAccessCheckPointProvider()
    @ObservedObject var extensionStatusProvider = FinderSyncExtensionStatusProvider()

    var body: some View {
        let accessGranted = checkpointProvider.accessGranted
        
        let (completed, value): (Bool?, String) = {
            switch accessGranted {
            case .none:
                let extensionStatus = extensionStatusProvider.extensionStatus
                switch (extensionStatus.enabled, extensionStatus.alienInfo) {
                case (.some(true), .same):
                    return (nil, "checking...")
                case (_, .alien):
                    return (nil, "not available due to problem with extension")
                case (_, .failing):
                    return (nil, "not available due to problem with extension")
                case (_, .none):
                    return (nil, "checking...")
                case (_, .some(.same)):
                    return (nil, "checking...")
                }
            case .unresponsive:
                let extensionStatus = extensionStatusProvider.extensionStatus
                switch (extensionStatus.enabled, extensionStatus.alienInfo) {
                case (.some(true), .same):
                    return (nil, "not yet connected")
                case (.some(true), .alien):
                    return (false, "alien")
                case (.some(true), .failing):
                    return (false, "failing")
                case (.some(true), nil):
                    return (false, "unresponsive")
                case (nil, _):
                    return (false, "unknown")
                case (.some(false), _):
                    return (false, "unknown (enable the extension)")
                }
            case .granted:
                return (true, "granted")
            case .denied:
                return (false, "denied")
            }
        }()
        
        CheckpointView(
            title: "Time Machine settings access",
            subtitle: "\(appName) reads the list of paths excluded from backup from Time Machine settings.",
            value: value,
            completed: completed
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

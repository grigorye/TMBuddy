import SwiftUI

struct PlugInFullDiskAccessCheckPointView: View {
    
    @ObservedObject var checkpointProvider = PlugInFullDiskAccessCheckPointProvider()
    @ObservedObject var extensionStatusProvider = FinderSyncExtensionStatusProvider()

    var body: some View {
        let accessGranted = checkpointProvider.accessGranted
        
        let (readiness, value): (Readiness, String) = {
            switch accessGranted {
            case .none:
                let extensionStatus = extensionStatusProvider.extensionStatus
                switch (extensionStatus.enabled, extensionStatus.alienInfo) {
                case (.some(true), .same):
                    return (.checking, "checking...")
                case (_, .alien):
                    return (.notActual, "unknown (alien extension)")
                case (_, .failing):
                    return (.notActual, "unknown (problem with extension)")
                case (_, .none):
                    return (.notActual, "checking...")
                case (_, .some(.same)):
                    return (.checking, "checking...")
                }
            case .unresponsive:
                let extensionStatus = extensionStatusProvider.extensionStatus
                switch (extensionStatus.enabled, extensionStatus.alienInfo) {
                case (.some(true), .same):
                    return (.checking, "not yet connected")
                case (.some(false), _):
                    return (.notActual, "unknown (enable the extension)")
                case (_, .alien):
                    return (.notActual, "unknown (alien extension)")
                case (_, .failing):
                    return (.notActual, "unknown (problem with extension)")
                case (_, .none):
                    return (.notActual, "unknown (no connection to extension)")
                case (_, .some(.same)):
                    return (.checking, "checking...")
                }
            case .granted:
                return (.ready, "granted")
            case .denied:
                return (.blocked, "denied")
            }
        }()
        
        CheckpointView(
            title: "Time Machine settings read rights",
            subtitle: "\(appName) reads the list of paths excluded from backup from Time Machine settings.",
            value: value,
            readiness: readiness
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

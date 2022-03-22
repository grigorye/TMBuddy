import SwiftUI

struct PlugInFullDiskAccessCheckpointView: View {
    
    struct State {
        let fullDiskAccess: PlugInFullDiskAccessCheckpointState
        let finderSync: FinderSyncExtensionCheckpointState
    }
    
    let state: State
    let actions: PlugInFullDiskAccessCheckpointActions?

    var body: some View {
        let accessGranted = state.fullDiskAccess
        
        let (readiness, value): (Readiness, LocalizedStringKey) = {
            switch accessGranted {
            case .none:
                let extensionStatus = state.finderSync
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
                let extensionStatus = state.finderSync
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
                        actions?.revealExtensionInFinder()
                    }
                    Button("Full Disk Access Preferences") {
                        actions?.openFullDiskAccessPreferences()
                    }
                }
                Text("To grant \(appName) access to Time Machine settings, please unlock Full Disk Access preferences and then drop \(plugInName) into the list of apps with allowed access.")
                    .font(.footnote)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .onVisibilityChange(perform: actions?.track(visible:))
    }
}

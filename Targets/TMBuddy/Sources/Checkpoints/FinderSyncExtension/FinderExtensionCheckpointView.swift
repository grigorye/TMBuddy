import FinderSync
import SwiftUI

struct FinderExtensionCheckpointView: View {
    
    @ObservedObject var extensionStatusProvider = FinderSyncExtensionStatusProvider()
    
    var body: some View {
        let (completed, value) = checkpointStatus
        
        let subtitle: String? = {
            let extensionStatus = extensionStatusProvider.extensionStatus
            switch (extensionStatus.enabled, extensionStatus.alienInfo) {
            case (_, .alien):
                return "Please reveal the alien extension in Finder, move it to Trash, and force relaunch Finder."
            case (.some(false), .same):
                return "Please force relaunch Finder to activate the other version of extension."
            case (.some(true), nil):
                return "Please force relaunch Finder to activate the extension"
            default:
                return nil
            }
        }()

        CheckpointView(
            title: "Finder extension",
            subtitle: subtitle,
            value: value,
            completed: completed
        ) {
            VStack(alignment: .leading) {
                HStack {
                    Button("Extensions Preferences") {
                        FIFinderSyncController.showExtensionManagementInterface()
                    }
                    if case let .alien(path: path) = extensionStatusProvider.extensionStatus.alienInfo {
                        Button("Reveal Alien Extension in Finder") {
                            NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: path)])
                        }
                    }
                }
            }
        }
    }
    
    var checkpointStatus: (Bool?, String) {
        let extensionStatus = extensionStatusProvider.extensionStatus
        switch (extensionStatus.enabled, extensionStatus.alienInfo) {
        case (.none, nil):
            return (nil, "checking...")
        case (.none, .some(.same)):
            return (nil, "unknown")
        case (.none, .some(.failing)):
            return (nil, "failing")
        case (_, .alien):
            return (false, "alien")
        case (.some(true), nil):
            return (nil, "enabled (no connection)...")
        case (.some(true), .same):
            return (true, "enabled")
        case (.some(false), nil):
            return (false, "disabled")
        case (.some(true), .failing):
            return (false, "enabled (failing)")
        case (.some(false), .same):
            return (false, "likely enabled (still connected), but superseded by another version")
        case (.some(false), .failing):
            return (false, "disabled (failing)")
        }
    }
}

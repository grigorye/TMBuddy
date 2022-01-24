import FinderSync
import SwiftUI

struct FinderExtensionCheckpointView: View {
    
    @ObservedObject var extensionStatusProvider = FinderSyncExtensionStatusProvider()
    
    var body: some View {
        let (completed, value) = checkpointStatus
        
        let alien: Bool = {
            if case .alien = extensionStatusProvider.extensionStatus.alienInfo {
                return true
            } else {
                return false
            }
        }()
        
        let subtitle: String? = {
            if alien {
                return "Please reveal the alien extension in Finder, move it to Trash, and force relaunch Finder."
            } else {
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
        case (.none, _):
            return (nil, "checking...")
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
        case (.some(false), .some(.same)):
            return (false, "likely enabled (still connected)")
        case (.some(false), .some(.failing)):
            return (false, "disabled (failing)")
        }
    }
}

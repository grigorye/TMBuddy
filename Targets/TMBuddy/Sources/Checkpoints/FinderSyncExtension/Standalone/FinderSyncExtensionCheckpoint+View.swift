import FinderSync
import SwiftUI

struct FinderSyncExtensionCheckpointView: View {
    
    typealias State = FinderSyncExtensionCheckpointState
    
    let state: State
    var actions: FinderSyncExtensionCheckpointActions!
    
    var body: some View {
        let (readiness, value) = checkpointStatus
        
        let subtitle: LocalizedStringKey? = {
            switch (state.enabled, state.alienInfo) {
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
            readiness: readiness
        ) {
            VStack(alignment: .leading) {
                HStack {
                    Button("Extensions Preferences") {
                        actions.showExtensionsPreferences()
                    }
                    if case let .alien(path: path) = state.alienInfo {
                        Button("Reveal Alien Extension in Finder") {
                            actions.revealAlienInFinder(path: path)
                        }
                    }
                }
            }
        }
    }
    
    var checkpointStatus: (Readiness, LocalizedStringKey) {
        switch (state.enabled, state.alienInfo) {
        case (.none, nil):
            return (.checking, "checking...")
        case (.none, .some(.same)):
            return (.checking, "unknown")
        case (.none, .some(.failing)):
            return (.checking, "failing")
        case (_, .alien):
            return (.blocked, "alien")
        case (.some(true), nil):
            return (.checking, "enabled (no connection)...")
        case (.some(true), .same):
            return (.ready, "enabled")
        case (.some(false), nil):
            return (.blocked, "disabled")
        case (.some(true), .failing):
            return (.blocked, "enabled (failing)")
        case (.some(false), .same):
            return (.blocked, "likely enabled (still connected), but superseded by another version")
        case (.some(false), .failing):
            return (.blocked, "disabled (failing)")
        }
    }
}

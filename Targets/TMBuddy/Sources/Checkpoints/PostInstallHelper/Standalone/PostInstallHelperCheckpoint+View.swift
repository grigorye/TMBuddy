import SwiftUI

struct PostInstallHelperCheckpointView: View {
    
    struct State {
        let bless: SMJobBlessCheckpointState
        let postInstall: PostInstallHelperCheckpointState
    }
    
    let state: State
    let actions: PostInstallHelperCheckpointActions?
    
    var body: some View {
        let readiness: Readiness = {
            guard case .blessed = state.bless else {
                return .notActual
            }
            switch state.postInstall {
            case .completed:
                return .ready
            case .skipped:
                return .notActual
            case .pending:
                return .blocked
            case .failing:
                return .blocked
            case .none:
                return .checking
            }
        }()
        let value: LocalizedStringKey = {
            guard case .blessed = state.bless else {
                return "unknown (helper tool is not installed)"
            }
            switch state.postInstall {
            case .completed:
                return "installed"
            case .skipped:
                return ""
            case .pending:
                return "not installed"
            case .failing:
                return "failing"
            case .none:
                return "checking"
            }
        }()
        
        CheckpointView(
            title: "Support for macOS \(ProcessInfo().operatingSystemVersion.majorVersion)",
            subtitle: nil,
            value: value,
            readiness: readiness
        ) {
            Button("Install Support", action: { actions?.installMacOSSupport() })
        }
        .onVisibilityChange(perform: actions?.trackVisibility)
    }
}

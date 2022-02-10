import SwiftUI

struct PostInstallHelperCheckpointView: View {
    
    init(
        checkpointProvider: StateHolder<PostInstallHelperCheckpointState>,
        blessCheckpointProvider: StateHolder<SMJobBlessCheckpointState>,
        actions: PostInstallHelperCheckpointActions?
    ) {
        self.actions = actions
        self.blessCheckpointProvider = blessCheckpointProvider
        self.checkpointProvider = checkpointProvider
    }
    
    @ObservedObject var blessCheckpointProvider: StateHolder<SMJobBlessCheckpointState>
    @ObservedObject var checkpointProvider: StateHolder<PostInstallHelperCheckpointState>
    let actions: PostInstallHelperCheckpointActions!
    
    var body: some View {
        let state = checkpointProvider.state
        let readiness: Readiness = {
            guard case .blessed = blessCheckpointProvider.state else {
                return .notActual
            }
            switch state {
            case .completed:
                return .ready
            case .none?:
                return .notActual
            case .pending:
                return .blocked
            case .failing:
                return .blocked
            case nil:
                return .checking
            }
        }()
        let value: String = {
            guard case .blessed = blessCheckpointProvider.state else {
                return "unknown (helper tool is not installed)"
            }
            switch state {
            case .completed:
                return "installed"
            case .none?:
                return ""
            case .pending:
                return "not installed"
            case .failing:
                return "failing"
            case nil:
                return "checking"
            }
        }()
        
        CheckpointView(
            title: "Support for macOS \(ProcessInfo().operatingSystemVersion.majorVersion)",
            subtitle: nil,
            value: value,
            readiness: readiness
        ) {
            Button("Install Support", action: actions.installMacOSSupport)
        }
    }
}

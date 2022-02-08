import SwiftUI
import Blessed

struct SMJobBlessCheckpointView: View {
    
    @ObservedObject var checkpointProvider = SMJobBlessCheckpointProvider()
    
    var body: some View {
        let state = checkpointProvider.state
        let value: String = {
            switch state {
            case .none:
                return "checking"
            case .blessed:
                return "installed"
            case .missingBless:
                return "not installed"
            case let .alien(version):
                return "outdated \(version)"
            }
        }()
        let readiness: Readiness = {
            switch state {
            case .none:
                return .checking
            case .blessed:
                return .ready
            case .missingBless:
                return .blocked
            case .alien:
                return .blocked
            }
        }()

        CheckpointView(
            title: "Helper tool",
            subtitle: "\(appName) uses the helper tool for changing Time Machine exclusion paths on behalf of the administrator.",
            value: value,
            readiness: readiness
        ) {
            HStack {
                switch state {
                case .blessed where bundleVersion == "Local":
                    Button("Reinstall Helper") {
                        let message = "\(appName) uses the helper tool for changing Time Machine exclusion paths on behalf of the administrator."
                        let icon = Bundle.main.url(forResource: "bless", withExtension: "png")
                        do {
                            try LaunchdManager.authorizeAndBless(message: message, icon: icon)
                        } catch {
                            NSApp.presentError(error)
                        }
                    }
                case .missingBless:
                    Button("Install Helper") {
                        let message = "\(appName) uses the helper tool for changing Time Machine exclusion paths on behalf of the administrator."
                        let icon = Bundle.main.url(forResource: "bless", withExtension: "png")
                        do {
                            try LaunchdManager.authorizeAndBless(message: message, icon: icon)
                        } catch {
                            NSApp.presentError(error)
                        }
                    }
                case .alien:
                    Button("Update Helper") {
                        let message = "\(appName) needs your permission to manipulate the Time Machine path exclusion list."
                        let icon = Bundle.main.url(forResource: "bless", withExtension: "png")
                        do {
                            try LaunchdManager.authorizeAndBless(message: message, icon: icon)
                        } catch {
                            NSApp.presentError(error)
                        }
                    }
                default:
                    EmptyView()
                }
            }
        }
    }
}

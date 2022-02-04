import SwiftUI
import Blessed

struct SMJobBlessCheckpointView: View {
    
    @ObservedObject var checkpointProvider = SMJobBlessCheckpointProvider()
    
    var body: some View {
        let value: String = {
            switch checkpointProvider.state {
            case .none:
                return "checking"
            case .toolInstalled:
                return "enabled"
            case .toolNotInstalled:
                return "not enabled"
            }
        }()
        let readiness: Readiness = {
            switch checkpointProvider.state {
            case .none:
                return .checking
            case .toolInstalled:
                return .ready
            case .toolNotInstalled:
                return .checking
            }
        }()
        
        CheckpointView(title: "Time Machine settings writing", subtitle: nil, value: value, readiness: readiness) {
            if checkpointProvider.state == .toolNotInstalled {
                Button("Install Helper") {
                    let message = "\(appName) needs your permission to manipulate the Time Machine path exclusion list."
                    let icon = Bundle.main.url(forResource: "bless", withExtension: "png")
                    do {
                        try LaunchdManager.authorizeAndBless(message: message, icon: icon)
                    } catch {
                        NSApp.presentError(error)
                    }
                }
            }
        }
    }
}

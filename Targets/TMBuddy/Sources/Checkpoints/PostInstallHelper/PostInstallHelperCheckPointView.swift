import SwiftUI

struct PostInstallHelperCheckpointView: View {
    
    @ObservedObject var blessCheckpointProvider = SMJobBlessCheckpointProvider()
    @ObservedObject var checkpointProvider = PostInstallHelperCheckpointProvider()
    
    var body: some View {
        let state = checkpointProvider.state
        let readiness: Readiness = {
            guard case .blessed = blessCheckpointProvider.state else {
                return .notActual
            }
            switch state {
            case .completed:
                return .ready
            case .none:
                return .notActual
            case .pending:
                return .blocked
            case .failing:
                return .blocked
            }
        }()
        let value: String = {
            guard case .blessed = blessCheckpointProvider.state else {
                return "unknown (helper tool is not installed)"
            }
            switch state {
            case .completed:
                return "installed"
            case .none:
                return ""
            case .pending:
                return "not installed"
            case .failing:
                return "failing"
            }
        }()
        CheckpointView(
            title: "Support for macOS \(ProcessInfo().operatingSystemVersion.majorVersion)",
            subtitle: nil,
            value: value,
            readiness: readiness
        ) {
            Button("Install Support") {
                let task = Task {
                    try await performCommonHelperXPC { (proxy: CommonHelperXPC, continuation) in
                        proxy.postInstallAsync(sourceBundlePath: Bundle.main.bundlePath) { error in
                            continuation.resume(with: Result(error: error))
                        }
                    }
                }
                Task {
                    let result = await task.result
                    dump(result, name: "postInstallResult")
                }
            }
        }
    }
}

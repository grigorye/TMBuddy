import SwiftUI

struct SMJobBlessCheckpointView: View {
    
    typealias State = SMJobBlessCheckpointState
    
    let state: State
    var actions: SMJobBlessCheckpointActions!
    
    var body: some View {
        let value: LocalizedStringKey = {
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
                    Button(
                        "Reinstall Helper",
                        action: { actions.reinstallHelper() }
                    )
                case .missingBless:
                    Button(
                        "Install Helper",
                        action: { actions.installHelper() }
                    )
                case .alien:
                    Button(
                        "Update Helper",
                        action: { actions.updateHandler() }
                    )
                default:
                    EmptyView()
                }
            }
        }
    }
}

struct SMJobBlessCheckpointView_Previews: PreviewProvider {
    
    static var previews: some View {
        Preview()
    }
}

private let samples = SMJobBlessCheckpointState.Sample.allCases

private struct Preview: View {
    
    @State var sampleIndex = 0
    
    var sample: SMJobBlessCheckpointState.Sample {
        samples[sampleIndex]
    }
    
    var state: SMJobBlessCheckpointState {
        sample.state
    }

    var nextSampleIndex: Int {
        let wouldBeNextSampleIndex = sampleIndex + 1
        guard wouldBeNextSampleIndex < samples.endIndex else {
            return 0
        }
        return wouldBeNextSampleIndex
    }
    
    var body: some View {
        VStack {
            Text(.verbatim("\(sample)"))
            Button(.verbatim("Next")) {
                sampleIndex = nextSampleIndex
            }
            SMJobBlessCheckpointView(state: state)
                .border(.red)
        }
        .padding()
    }
}

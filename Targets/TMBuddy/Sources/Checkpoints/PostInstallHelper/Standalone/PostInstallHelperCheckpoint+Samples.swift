extension PostInstallHelperCheckpointView.State {
    
    typealias State = Self
    
    struct Sample: StateSample {
        
        typealias Namespace = State
        
        var state: State {
            State(bless: bless.state, postInstall: postInstall.state)
        }
        
        static var allCases: [Self] {
            PostInstallHelperCheckpointState.Sample.allCases.flatMap { postInstall in
                SMJobBlessCheckpointState.Sample.allCases.map { bless in
                    Self(bless: bless, postInstall: postInstall)
                }
            }
        }
        
        let bless: SMJobBlessCheckpointState.Sample
        let postInstall: PostInstallHelperCheckpointState.Sample
    
        var sampleName: String {
            [
                bless.sampleName,
                postInstall.sampleName
            ].joined(separator: "_")
        }
    }
    
    static let none = Self(bless: .none, postInstall: .none)
}

extension PostInstallHelperCheckpointState {
    
    typealias State = Self
    
    enum Sample: CaseIterable, SampleNaming {
        
        typealias Namespace = State
        
        case none
        case skipped
        case completed
        case pending
        case failing
        
        var state: State {
            switch self {
            case .none:
                return .none
            case .skipped:
                return .skipped
            case .completed:
                return .completed
            case .pending:
                return .pending
            case .failing:
                return .failing(FakeError.fakeFailure)
            }
        }
    }
}

enum FakeError: Error {
    case fakeFailure
}

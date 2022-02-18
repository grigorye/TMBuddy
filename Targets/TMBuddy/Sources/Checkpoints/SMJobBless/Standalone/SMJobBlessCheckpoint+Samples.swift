extension SMJobBlessCheckpointState {
    
    typealias State = Self
    
    enum Sample: StateSample {
        
        typealias Namespace = State
        
        case none
        case blessed
        case alien
        case missingBless
        
        var state: State {
            switch self {
            case .none:
                return .none
            case .blessed:
                return .blessed
            case .alien:
                return .alien("sample")
            case .missingBless:
                return .missingBless
            }
        }
    }
}

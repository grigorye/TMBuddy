extension FinderSyncExtensionCheckpointState {
    
    typealias State = Self
    
    enum Sample: CaseIterable, StateSample {
        
        typealias Namespace = State
        
        case none
        case enabled
        case disabled
        case alien
        
        var state: State {
            switch self {
            case .none:
                return .none
            case .disabled:
                return .init(enabled: false, alienInfo: .none)
            case .enabled:
                return .init(enabled: true, alienInfo: .none)
            case .alien:
                return .init(enabled: true, alienInfo: .alien(path: "/foo/bar"))
            }
        }
    }
}

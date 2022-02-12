extension SandboxAccessView.State {
    
    typealias State = Self
    
    static let none = Self(showPostInstall: false, showDebug: false)
    
    enum Sample: CaseIterable, SampleNaming {
        
        typealias Namespace = State
        
        case none
        case compact
        case full
        
        var state: State {
            switch self {
            case .none:
                return .none
            case .compact:
                return .init(showPostInstall: false, showDebug: false)
            case .full:
                return .init(showPostInstall: true, showDebug: true)
            }
        }
    }
}

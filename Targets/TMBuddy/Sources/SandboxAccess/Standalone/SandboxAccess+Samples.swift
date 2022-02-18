extension SandboxAccessView.State {
    
    typealias State = Self
    
    static let none = Self(showPostSMJobBless: false, showPostInstall: false, showDebug: false)
    
    enum Sample: StateSample {
        typealias Namespace = State
        
        case none
        case compact
        case full
        
        var state: State {
            switch self {
            case .none:
                return .none
            case .compact:
                return .init(showPostSMJobBless: false, showPostInstall: false, showDebug: false)
            case .full:
                return .init(showPostSMJobBless: true, showPostInstall: true, showDebug: true)
            }
        }
    }
}

extension LegendView.State {
    
    typealias State = Self
    static let none = Self()
    
    enum Sample: CaseIterable, StateSample {
        
        typealias Namespace = State
        
        case none
        
        var state: State {
            switch self {
            case .none:
                return .none
            }
        }
    }
}

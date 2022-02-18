extension FolderSelectionCheckpointView.State {
    
    static let none = Self(bookmarkCount: 0)
    
    typealias State = Self
    
    enum Sample: CaseIterable, StateSample {
        
        typealias Namespace = State
        
        case none
        case one
        case many
        
        var state: State {
            switch self {
            case .none:
                return .init(bookmarkCount: 0)
            case .one:
                return .init(bookmarkCount: 1)
            case .many:
                return .init(bookmarkCount: 10)
            }
        }
    }
}

extension PlugInFullDiskAccessCheckpointState {
    
    typealias State = Self
    
    enum Sample: StateSample {
        
        typealias Namespace = State
        
        case granted
        case denied
        case unresponsive
        case none

        var state: State {
            switch self {
            case .granted:
                return .granted
            case .denied:
                return .denied
            case .unresponsive:
                return .unresponsive
            case .none:
                return .none
            }
        }
    }
}

extension PlugInFullDiskAccessCheckpointView.State {
    
    typealias State = Self
    
    struct Sample: StateSample {
        
        typealias Namespace = State
        
        var state: State {
            State(fullDiskAccess: fullDiskAccess.state, finderSync: finderSync.state)
        }
        
        static var allCases: [Self] {
            PlugInFullDiskAccessCheckpointState.Sample.allCases.flatMap { fullDiskAccess in
                FinderSyncExtensionCheckpointState.Sample.allCases.map { finderSync in
                    Self(fullDiskAccess: fullDiskAccess, finderSync: finderSync)
                }
            }
        }
        
        let fullDiskAccess: PlugInFullDiskAccessCheckpointState.Sample
        let finderSync: FinderSyncExtensionCheckpointState.Sample
    
        var sampleName: String {
            [
                fullDiskAccess.sampleName,
                finderSync.sampleName
            ].joined(separator: "_")
        }
    }
    
    static let none = Self(fullDiskAccess: .none, finderSync: .none)
}

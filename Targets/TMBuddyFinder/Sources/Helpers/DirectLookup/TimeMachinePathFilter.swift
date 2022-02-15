import Foundation

class TimeMachinePathFilter {
    
    private var userDefaultsObserver: UserDefaultsObserver?
    
    init() {
        userDefaultsObserver = .init(
            defaults: timeMachineUserDefaults,
            key: TimeMachineUserDefaultsKey.skipPaths.rawValue,
            options: [.initial, .new]
        ) { [weak self] change in
            self?.observeTimeMachineSkipPaths(change)
        }
    }
    
    func observeTimeMachineSkipPaths(_ change: [NSKeyValueChangeKey : Any]?) {
        let newSkipPaths: [String]
        switch change?[.newKey] {
        case _ as NSNull:
            newSkipPaths = []
        case let paths as [String]:
            newSkipPaths = paths.map { ($0 as NSString).expandingTildeInPath(ignoringSandbox: true) }
        default:
            dump(change, name: "changeFailed")
            newSkipPaths = []
        }
        dump(newSkipPaths, name: "newSkipPaths")
        
        self.skipPaths = newSkipPaths
    }
    func isExcluded(_ url: URL) -> Bool {
        filter.isExcluded(url)
    }
    
    var skipPaths: [String] = []
    
    var filter: PathFilter {
        PathFilter(skipPaths: skipPaths)
    }
}

extension TimeMachinePathFilter: Traceable {}

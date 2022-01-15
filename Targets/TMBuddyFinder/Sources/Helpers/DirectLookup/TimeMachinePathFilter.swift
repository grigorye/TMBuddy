import Foundation

class TimeMachinePathFilter {
    
    private var userDefaultsObserver: UserDefaultsObserver?
    
    init() {
        userDefaultsObserver = .init(
            defaults: UserDefaults(suiteName: "com.apple.TimeMachine")!,
            key: "SkipPaths",
            options: [.initial, .new]
        ) { [weak self] change in
            let newSkipPaths: [String]
            switch change?[.newKey] {
            case _ as NSNull:
                newSkipPaths = []
            case let paths as [String]:
                newSkipPaths = paths.map { ($0 as NSString).expandingTildeInPath }
            default:
                dump(change, name: "unrecognizedChange")
                newSkipPaths = []
            }
            dump(newSkipPaths, name: "newSkipPaths")
            self?.skipPaths = newSkipPaths
        }
    }
    
    func isExcluded(_ url: URL) -> Bool {
        filter.isExcluded(url)
    }
    
    var skipPaths: [String] = []
    
    var filter: PathFilter {
        PathFilter(skipPaths: skipPaths)
    }
}

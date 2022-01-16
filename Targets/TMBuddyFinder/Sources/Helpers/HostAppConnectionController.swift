import Foundation

class HostAppConnectionController {
    
    private let defaults = sharedDefaults
    private var userDefaultsObserver: UserDefaultsObserver?
    
    init() {
        userDefaultsObserver = .init(
            defaults: defaults,
            key: DefaultsKey.finderSyncInfoRequestIndex.rawValue,
            options: [.initial, .new]
        ) { [weak self] change in
            self?.observeFinderSyncInfoRequestDate(change)
        }
    }
    
    func observeFinderSyncInfoRequestDate(_ change: [NSKeyValueChangeKey : Any]?) {
        let requestIndex = defaults.finderSyncInfoRequestIndex
        let responseIndex = defaults.finderSyncInfoResponseIndex
        debug { dump((requestIndex: requestIndex, responseIndex: responseIndex), name: "requestResponse") }
        
        guard responseIndex < requestIndex else {
            debug { dump((responseIndex: responseIndex, requestIndex: requestIndex), name: "responseIsAlreadyThere") }
            return
        }
        
        let response = FinderSyncInfoResponse(
            version: plugInHostConnectionVersion,
            timeMachinePreferencesAccess: {
                if let error = timeMachinePreferencesAccessError() {
                    return .denied(error.localizedDescription)
                } else {
                    return .granted
                }
            }()
        )
        defaults.finderSyncInfoResponsePayload = try! JSONEncoder().encode(response)
        defaults.finderSyncInfoResponseIndex = requestIndex
    }
    
    func isExcluded(_ url: URL) -> Bool {
        filter.isExcluded(url)
    }
    
    var skipPaths: [String] = []
    
    var filter: PathFilter {
        PathFilter(skipPaths: skipPaths)
    }
}

extension HostAppConnectionController: Traceable {}

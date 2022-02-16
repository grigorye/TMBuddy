import Foundation

class TimeMachineVolumeFilter {
    
    private var userDefaultsObserver: UserDefaultsObserver?
    
    init() {
        userDefaultsObserver = .init(
            defaults: timeMachineUserDefaults,
            key: TimeMachineUserDefaultsKey.excludedVolumeUUIDs.rawValue,
            options: [.initial, .new]
        ) { [weak self] change in
            self?.observeExcludedVolumeUUIDs(change)
        }
    }
    
    func observeExcludedVolumeUUIDs(_ change: [NSKeyValueChangeKey : Any]?) {
        let newExcludedVolumeUUIDs: [String]
        dump(change, name: "change")
        switch change?[.newKey] {
        case _ as NSNull:
            newExcludedVolumeUUIDs = []
        case let volumeUUIDs as [String]:
            newExcludedVolumeUUIDs = volumeUUIDs
        default:
            dump(change, name: "changeFailed")
            newExcludedVolumeUUIDs = []
        }
        dump(newExcludedVolumeUUIDs, name: "newExcludedVolumeUUIDs")
        
        self.excludedVolumeUUIDs = newExcludedVolumeUUIDs
    }
    
    func isExcluded(_ url: URL) -> Bool {
        filter.isExcluded(url)
    }
    
    var excludedVolumeUUIDs: [String] = []
    
    var filter: VolumeFilter {
        .init(excludedVolumeUUIDs: excludedVolumeUUIDs)
    }
}

extension TimeMachineVolumeFilter: Traceable {}

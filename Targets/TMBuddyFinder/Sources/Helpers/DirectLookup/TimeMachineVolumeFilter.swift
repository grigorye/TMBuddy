import Foundation

class TimeMachineVolumeFilter {
    
    private var userDefaultsObserver: UserDefaultsObserver?
    
    init() {
        userDefaultsObserver = .init(
            defaults: UserDefaults(suiteName: "com.apple.TimeMachine")!,
            key: "ExcludedVolumeUUIDs",
            options: [.initial, .new]
        ) { [weak self] change in
            let newExcludedVolumeUUIDs: [String]
            dump(change, name: "change")
            switch change?[.newKey] {
            case _ as NSNull:
                newExcludedVolumeUUIDs = []
            case let volumeUUIDs as [String]:
                newExcludedVolumeUUIDs = volumeUUIDs
            default:
                dump(change, name: "unrecognizedChange")
                newExcludedVolumeUUIDs = []
            }
            dump(newExcludedVolumeUUIDs, name: "newExcludedVolumeUUIDs")
            self?.excludedVolumeUUIDs = newExcludedVolumeUUIDs
        }
    }
    
    func isExcluded(_ url: URL) throws -> Bool {
        try filter.isExcluded(url)
    }
    
    var excludedVolumeUUIDs: [String] = []
    
    var filter: VolumeFilter {
        .init(excludedVolumeUUIDs: excludedVolumeUUIDs)
    }
}

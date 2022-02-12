import SwiftUI

class DebugFlagProvider: ObservableObject {
    
    @Published var debugIsEnabled: Bool = false
    
    private let defaults = sharedDefaults
    
    private var userDefaultsObserver: UserDefaultsObserver?
    
    init() {
        userDefaultsObserver = .init(
            defaults: defaults,
            key: DefaultsKey.debug.rawValue,
            options: [.initial, .new]
        ) { [weak self] change in
            self?.observeDebug(change)
        }
    }
    
    private func observeDebug(_ change: [NSKeyValueChangeKey : Any]?) {
        debugIsEnabled = defaults.bool(forKey: DefaultsKey.debug)
    }
}

extension DebugFlagProvider: Traceable {}

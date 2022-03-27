#if canImport(Firebase)

import Firebase
import Foundation

class FirebaseAnalyticsEnabler: NSObject {
    
    var userDefaultsObserver: UserDefaultsObserver?
    let defaults = sharedDefaults
    
    override init() {
        super.init()
        
        userDefaultsObserver = .init(
            defaults: defaults,
            key: DefaultsKey.analyticsEnabled.rawValue,
            options: [.initial]
        ) { [weak self] change in
            self?.observeAnalyticsEnabled()
        }
    }
    
    private func observeAnalyticsEnabled() {
        let analyticsEnabled = defaults.analyticsEnabled
        dump(analyticsEnabled, name: "analyticsEnabled")
        Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)
    }
}

extension FirebaseActionTracker: Traceable {}

#endif

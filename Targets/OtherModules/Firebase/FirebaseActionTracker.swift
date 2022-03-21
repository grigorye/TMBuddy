#if canImport(FirebaseAnalytics)

import FirebaseAnalytics

struct FirebaseActionTracker: ActionTracker {
    
    func activate() {
        activateFirebase()
    }
    
    func trackAction(_ action: TrackedAction) {
        Analytics.logEvent("action", parameters: [
            "name": action.name
        ])
    }
}

#endif

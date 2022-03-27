import Foundation

class AnalyticsCheckpointActionsHandler: Traceable, AnalyticsCheckpointActions {
    
    let defaults = sharedDefaults
    
    func setAnalyticsEnabled() {
        dump((), name: "")
        setAnalytics(enabled: true)
    }
    
    func setAnalyticsDisabled() {
        dump((), name: "")
        setAnalytics(enabled: false)
    }
    
    func setAnalytics(enabled: Bool) {
        defaults.analyticsEnabled = enabled
        defaults.synchronize()
    }
}

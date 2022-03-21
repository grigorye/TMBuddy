import Foundation

class AnalyticsCheckpointActionsHandler: Traceable, AnalyticsCheckpointActions {
    
    func setAnalyticsEnabled() {
        dump((), name: "")
        setAnalytics(enabled: true)
    }
    
    func setAnalyticsDisabled() {
        dump((), name: "")
        setAnalytics(enabled: false)
    }
    
    func setAnalytics(enabled: Bool) {
        UserDefaults.standard.actionTrackingEnabled = enabled
        UserDefaults.standard.errorReportingEnabled = enabled
        UserDefaults.standard.synchronize()
    }
}

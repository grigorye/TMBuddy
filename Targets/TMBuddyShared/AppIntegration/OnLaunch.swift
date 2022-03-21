import Foundation

func onLaunch() {
    activateErrorReporting()
    activateActionTracking()
    checkSanity()
}

func activateErrorReporting() {
    guard UserDefaults.standard.errorReportingEnabled else {
        return
    }
#if canImport(FirebaseCrashlytics)
    let crashlyticsErrorReporter = CrashlyticsErrorReporter()
    crashlyticsErrorReporter.activate()
    errorReporters += [crashlyticsErrorReporter]
#endif
}

func activateActionTracking() {
    guard UserDefaults.standard.actionTrackingEnabled else {
        return
    }
    actionTrackers += [simpleActionTracker]
#if canImport(FirebaseAnalytics)
    let firebaseActionTracker = FirebaseActionTracker()
    firebaseActionTracker.activate()
    actionTrackers += [firebaseActionTracker]
#endif
}

private let simpleActionTracker = SimpleActionTracker()

struct SimpleActionTracker: ActionTracker {
    func trackAction(_ action: TrackedAction) {
        dump(action.name, name: "trackedAction")
    }
}

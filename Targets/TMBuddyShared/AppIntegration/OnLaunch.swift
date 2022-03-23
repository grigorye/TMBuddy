import Foundation

func onLaunch() {
    registerDefaults()
    activateErrorReporting()
    activateActionTracking()
    checkSanity()
}

func registerDefaults() {
    let defaults: [DefaultsKey: Any] = [
        .errorReportingEnabled: true,
        .actionTrackingEnabled: true
    ]
    UserDefaults.standard.register(
        defaults: defaults.reduce(into: [:], { (d, x) in
            d[x.key.rawValue] = x.value
        })
    )
}

func activateErrorReporting() {
    guard defaults.errorReportingEnabled || defaults.analyticsEnabled else {
        return
    }
#if canImport(FirebaseCrashlytics)
    let crashlyticsErrorReporter = CrashlyticsErrorReporter()
    crashlyticsErrorReporter.activate()
    errorReporters += [crashlyticsErrorReporter]
#endif
}

func activateActionTracking() {
    guard defaults.actionTrackingEnabled || defaults.analyticsEnabled else {
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

private let defaults = UserDefaults.standard

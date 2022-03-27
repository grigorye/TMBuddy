import Foundation

func onLaunch() {
    registerDefaults()
    activateErrorReporting()
    activateActionTracking()
    activateElapsedTimeTracking()
    activateActivityTracking()
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

func activateElapsedTimeTracking() {
    guard defaults.elapsedTimeTrackingEnabled || defaults.analyticsEnabled else {
        return
    }
    elapsedTimeTrackers += [SimpleElapsedTimeTracker()]
}

func activateActionTracking() {
    guard defaults.actionTrackingEnabled || defaults.analyticsEnabled else {
        return
    }
    actionTrackers += [SimpleActionTracker()]
#if canImport(FirebaseAnalytics)
    let firebaseActionTracker = FirebaseActionTracker()
    firebaseActionTracker.activate()
    actionTrackers += [firebaseActionTracker]
#endif
}

func activateActivityTracking() {
    guard defaults.activityTrackingEnabled || defaults.analyticsEnabled else {
        return
    }
    activityTrackers += [SimpleActivityTracker()]
#if canImport(FirebasePerformance)
    let firebaseActivityTracker = FirebaseActivityTracker()
    firebaseActivityTracker.activate()
    activityTrackers += [firebaseActivityTracker]
#endif
}

struct SimpleActionTracker: ActionTracker {
    func trackAction(_ action: TrackedAction) {
        dump(action.name, name: "trackedAction")
    }
}

struct SimpleElapsedTimeTracker: ElapsedTimeTracker {
    func trackElapsedTime<T>(_ value: T, name: String?, sourceInfo: SourceInfo) {
        _ = value
    }
}

struct SimpleActivityTracker: ActivityTracker {
    func beginActivity<T>(_ value: T, name: String, sourceInfo: SourceInfo) -> TrackedActivity {
        dump(value, name: name + ".activityBegan", sourceInfo: sourceInfo)
        return SimpleTrackedActivity(name: name)
    }
}

struct SimpleTrackedActivity: TrackedActivity {
    let timestamp = Date()
    let name: String
    
    func endActivity<T>(_ value: T, sourceInfo: (SourceInfo)) {
        let elapsed = Date().timeIntervalSince(timestamp)
        dump((elapsed: elapsed, value), name: name + ".activityEnded", sourceInfo: sourceInfo)
    }
}

private let defaults = UserDefaults.standard

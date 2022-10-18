import Foundation

func onLaunch() {
    registerDefaults()
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

func defaultErrorReporters() -> [ErrorReporter] {
    var errorReporters: [ErrorReporter] = []
    guard defaults.errorReportingEnabled || sharedDefaults.analyticsEnabled else {
        return []
    }
#if canImport(FirebaseCrashlytics)
    let crashlyticsErrorReporter = CrashlyticsErrorReporter()
    crashlyticsErrorReporter.activate()
    errorReporters += [crashlyticsErrorReporter]
#endif
    return errorReporters
}

func defaultElapsedTimeTrackers() -> [ElapsedTimeTracker] {
    var elapsedTimeTrackers: [ElapsedTimeTracker] = []
    guard defaults.elapsedTimeTrackingEnabled || sharedDefaults.analyticsEnabled else {
        return []
    }
    elapsedTimeTrackers += [SimpleElapsedTimeTracker()]
    return elapsedTimeTrackers
}

func defaultActionTrackers() -> [ActionTracker] {
    var actionTrackers: [ActionTracker] = []
    guard defaults.actionTrackingEnabled || sharedDefaults.analyticsEnabled else {
        return []
    }
    actionTrackers += [SimpleActionTracker()]
#if canImport(FirebaseAnalytics)
    let firebaseActionTracker = FirebaseActionTracker()
    firebaseActionTracker.activate()
    actionTrackers += [firebaseActionTracker]
#endif
    return actionTrackers
}

func defaultActivityTrackers() -> [ActivityTracker] {
    var activityTrackers: [ActivityTracker] = []
    guard defaults.activityTrackingEnabled || sharedDefaults.analyticsEnabled else {
        return []
    }
    activityTrackers += [SimpleActivityTracker()]
#if canImport(FirebasePerformance)
    let firebaseActivityTracker = FirebaseActivityTracker()
    firebaseActivityTracker.activate()
    activityTrackers += [firebaseActivityTracker]
#endif
    return activityTrackers
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
    let timeIntervalSinceReferenceDate = Date().timeIntervalSinceReferenceDate
    var timestamp: Date { Date(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDate) }
    let name: String
    
    func endActivity<T>(_ value: T, sourceInfo: (SourceInfo)) {
        let elapsed = Date().timeIntervalSince(timestamp)
        dump((elapsed: elapsed, value), name: name + ".activityEnded", sourceInfo: sourceInfo)
    }
}

private let defaults = UserDefaults.standard

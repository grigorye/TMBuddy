func onLaunch() {
    activateErrorReporting()
    activateActionTracking()
    checkSanity()
}

func activateErrorReporting() {
#if canImport(FirebaseCrashlytics)
    let crashlyticsErrorReporter = CrashlyticsErrorReporter()
    crashlyticsErrorReporter.activate()
    errorReporters += [crashlyticsErrorReporter]
#endif
}

func activateActionTracking() {
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

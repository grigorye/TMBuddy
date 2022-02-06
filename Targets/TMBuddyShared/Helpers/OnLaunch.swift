func onLaunch() {
    activateErrorReporting()
    checkSanity()
}

func activateErrorReporting() {
    #if canImport(FirebaseCrashlytics)
    let crashlyticsErrorReporter = CrashlyticsErrorReporter()
    crashlyticsErrorReporter.activate()
    errorReporters += [crashlyticsErrorReporter]
    #endif
}

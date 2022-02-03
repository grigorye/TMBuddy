func onLaunch() {
    activateErrorReporting()
    checkSanity()
}

func activateErrorReporting() {
    let crashlyticsErrorReporter = CrashlyticsErrorReporter()
    crashlyticsErrorReporter.activate()
    errorReporters += [crashlyticsErrorReporter]
}

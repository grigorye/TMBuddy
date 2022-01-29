import FirebaseCrashlytics

func activateErrorReporting() {
    activateFirebase()
}

func reportError<T>(_ value: T, name: String, file: String, function: String, line: Int, callStack: CallStack) {
    let exceptionModel = ExceptionModel(name: name, reason: "\(Swift.dump(value))") ≈ {
        $0.stackTrace = callStack.returnAddresses.map { StackFrame(address: $0.uintValue) }
    }
    Crashlytics.crashlytics().record(exceptionModel: exceptionModel)
}

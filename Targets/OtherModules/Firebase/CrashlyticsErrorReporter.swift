#if canImport(FirebaseCrashlytics)

import FirebaseCrashlytics

struct CrashlyticsErrorReporter: ErrorReporter {
    
    func activate() {
        activateFirebase()
        
        UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions" : true])
    }

    func reportError<T>(_ value: T, name: String?, file: StaticString, function: String, line: Int, callStack: CallStack) {
        let exceptionModel = ExceptionModel(name: name ?? "Unnamed", reason: "\(Swift.dump(value))") ≈ {
            $0.stackTrace = callStack.returnAddresses.map { StackFrame(address: $0.uintValue) }
        }
#if DEBUG
        _ = exceptionModel
#else
        Crashlytics.crashlytics().record(exceptionModel: exceptionModel)
#endif
    }
}

#endif

#if canImport(FirebaseCrashlytics)

import FirebaseCrashlytics

struct CrashlyticsErrorReporter: ErrorReporter {
    
    func activate() {
        activateFirebase()
        
        UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions" : true])
    }

    func reportError<T>(_ value: T, name: String?, sourceInfo s: SourceInfo) {
        let exceptionModel = ExceptionModel(name: name ?? "Unnamed", reason: "\(Swift.dump(value))") ≈ {
            $0.stackTrace = s.callStack.returnAddresses.map { StackFrame(address: $0.uintValue) }
        }
        Crashlytics.crashlytics().record(exceptionModel: exceptionModel)
    }
}

#endif

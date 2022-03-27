#if canImport(FirebasePerformance)

import FirebasePerformance

struct FirebaseActivityTracker: ActivityTracker {
    
    func activate() {
        activateFirebase()
    }
    
    func beginActivity<T>(_ value: T, name: String, sourceInfo: SourceInfo) -> TrackedActivity {
        guard let trace = Performance.startTrace(name: name) else {
            assertionFailure()
            return DummyTrackedActivity()
        }
        return FirebaseTrackedActivity(trace: trace)
    }
}

struct FirebaseTrackedActivity: TrackedActivity {
    let trace: Trace
    
    func endActivity<T>(_ value: T, sourceInfo: (SourceInfo)) {
        trace.stop()
    }
}

struct DummyTrackedActivity: TrackedActivity {
    func endActivity<T>(_ value: T, sourceInfo: (SourceInfo)) {
    }
}

#endif

#if canImport(FirebasePerformance)

import FirebasePerformance

struct FirebaseActivityTracker: ActivityTracker {
    
    func activate() {
        activateFirebase()
    }
    
    func beginActivity<T>(_ value: T, name: String, sourceInfo: SourceInfo) -> TrackedActivity {
        dump(name, name: "")
        guard let trace = Performance.startTrace(name: name) else {
            assertionFailure()
            return DummyTrackedActivity(name: name)
        }
        return FirebaseTrackedActivity(trace: trace, name: name)
    }
}

struct FirebaseTrackedActivity: TrackedActivity {
    let trace: Trace
    let name: String
    
    init(trace: Trace, name: String) {
        self.trace = trace
        self.name = name
        
        dump(name, name: "")
    }
    
    func endActivity<T>(_ value: T, sourceInfo: (SourceInfo)) {
        dump(name, name: "")
        trace.stop()
    }
}

struct DummyTrackedActivity: TrackedActivity {
    let name: String
    
    init(name: String) {
        self.name = name
        
        dump(name, name: "")
    }
    func endActivity<T>(_ value: T, sourceInfo: (SourceInfo)) {
        dump(name, name: "")
    }
}

#endif

import Foundation

protocol ActivityTracker {
    func beginActivity<T>(_ value: T, name: String, sourceInfo: SourceInfo) -> TrackedActivity
}

protocol TrackedActivity {
    func endActivity<T>(_ value: T, sourceInfo: (SourceInfo))
}

extension TrackedActivity {
    func end<T>(_ value: T, file: StaticString = #file, function: StaticString = #function, line: Int = #line, callStack: CallStack = .init()) {
        let sourceInfo = SourceInfo(file: file, function: function, line: line, callStack: callStack)
        endActivity(value, sourceInfo: sourceInfo)
    }
}

var activityTrackers: [ActivityTracker] = []

func beginActivity<T>(_ value: T, name: String, sourceInfo: SourceInfo) -> TrackedActivity {
    let activities = activityTrackers.map {
        $0.beginActivity(value, name: name, sourceInfo: sourceInfo)
    }
    return CompositeTrackedActivity(activities: activities)
}

struct CompositeTrackedActivity: TrackedActivity {
    let activities: [TrackedActivity]
    
    func endActivity<T>(_ value: T, sourceInfo: (SourceInfo)) {
        activities.forEach {
            $0.endActivity(value, sourceInfo: sourceInfo)
        }
    }
}

func beginActivity<T>(_ value: T, name: String, file: StaticString = #file, function: StaticString = #function, line: Int = #line, callStack: CallStack = .init()) -> TrackedActivity {
    let sourceInfo = SourceInfo(file: file, function: function, line: line, callStack: callStack)
    return beginActivity(value, name: name, sourceInfo: sourceInfo)
}

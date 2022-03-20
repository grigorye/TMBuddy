import Foundation

func shouldBeReportedAsAction<T>(_ value: T, name: String?, file: StaticString, function: String, line: Int, callStack: CallStack) -> Bool {
    guard let name = name else {
        return false
    }
    guard name == "" else {
        return false
    }
    guard value is () else {
        return false
    }
    return true
}

func hookActionTrackersForDump<T>(_ value: T, name: String?, file: StaticString, function: String, line: Int, callStack: CallStack) {
    guard shouldBeReportedAsAction(value, name: name, file: file, function: function, line: line, callStack: callStack) else {
        return
    }

    let action = TrackedAction(name: function)
    
    if !UserDefaults.standard.bool(forKey: DefaultsKey.suppressActionTracking) {
        actionTrackers.forEach {
            $0.trackAction(action)
        }
    }
}

struct TrackedAction {
    let name: String
}

protocol ActionTracker {
    func trackAction(_ action: TrackedAction)
}

var actionTrackers: [ActionTracker] = []

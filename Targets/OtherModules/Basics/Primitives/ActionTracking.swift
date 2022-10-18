import Foundation

func shouldBeReportedAsAction<T>(_ value: T, name: String?, sourceInfo: SourceInfo) -> Bool {
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

func hookActionTrackersForDump<T>(_ value: T, name: String?, sourceInfo: SourceInfo) {
    guard shouldBeReportedAsAction(value, name: name, sourceInfo: sourceInfo) else {
        return
    }

    let action = TrackedAction(name: sourceInfo.function)
    
    actionTrackers.forEach {
        $0.trackAction(action)
    }
}

struct TrackedAction {
    let name: String
}

protocol ActionTracker {
    func trackAction(_ action: TrackedAction)
}

let actionTrackers: [ActionTracker] = defaultActionTrackers()

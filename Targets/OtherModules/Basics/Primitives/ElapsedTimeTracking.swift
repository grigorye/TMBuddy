import Foundation

func shouldBeReportedAsElapsedTime<T>(_ value: T, name: String?, sourceInfo: SourceInfo) -> Bool {
    guard let name = name else {
        return false
    }
    guard name.hasSuffix("Elapsed") else {
        return false
    }
    return true
}

func hookElapsedTimeTrackersForDump<T>(_ value: T, name: String?, sourceInfo: SourceInfo) {
    guard shouldBeReportedAsElapsedTime(value, name: name, sourceInfo: sourceInfo) else {
        return
    }

    elapsedTimeTrackers.forEach {
        $0.trackElapsedTime(value, name: name, sourceInfo: sourceInfo)
    }
}

protocol ElapsedTimeTracker {
    func trackElapsedTime<T>(_ value: T, name: String?, sourceInfo: SourceInfo)
}

var elapsedTimeTrackers: [ElapsedTimeTracker] = []

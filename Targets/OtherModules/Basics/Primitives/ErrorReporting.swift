import Foundation
import os.log

func shouldBeReportedAsError(name: String?, sourceInfo: SourceInfo) -> Bool {
    guard let name = name else {
        return false
    }
    guard name.hasSuffix("Failed") || (name.hasSuffix("Error") && name != "standardError") || name == "error" else {
        return false
    }
    return true
}

func logType(name: String?, sourceInfo: SourceInfo) -> OSLogType {
    shouldBeReportedAsError(name: name, sourceInfo: sourceInfo)
    ? .error
    : .default
}

func hookErrorReportersForDump<T>(_ value: T, name: String?, sourceInfo: SourceInfo) {
    
    guard shouldBeReportedAsError(name: name, sourceInfo: sourceInfo) else {
        return
    }
    
    errorReporters.forEach {
        $0.reportError(value, name: name, sourceInfo: sourceInfo)
    }
}

let errorReporters: [ErrorReporter] = defaultErrorReporters()

protocol ErrorReporter {
    func reportError<T>(_ value: T, name: String?, sourceInfo: SourceInfo)
}

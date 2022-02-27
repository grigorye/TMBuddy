import Foundation
import os.log

func postDump<T>(_ value: T, name: String?, file: StaticString, function: String, line: Int, callStack: CallStack) {
    hookErrorReportersForDump(value, name: name, file: file, function: function, line: line, callStack: callStack)
}

func shouldBeReportedAsError(name: String?, file: StaticString, function: String, line: Int, callStack: CallStack) -> Bool {
    guard let name = name else {
        return false
    }
    guard name.hasSuffix("Failed") || (name.hasSuffix("Error") && name != "standardError") || name == "error" else {
        return false
    }
    return true
}

func logType(name: String?, file: StaticString, function: String, line: Int, callStack: CallStack) -> OSLogType {
    shouldBeReportedAsError(name: name, file: file, function: function, line: line, callStack: callStack)
    ? .error
    : .default
}

private func hookErrorReportersForDump<T>(_ value: T, name: String?, file: StaticString, function: String, line: Int, callStack: CallStack) {
    
    guard shouldBeReportedAsError(name: name, file: file, function: function, line: line, callStack: callStack) else {
        return
    }
    
    if !UserDefaults.standard.bool(forKey: DefaultsKey.suppressErrorReporting) {
        errorReporters.forEach {
            $0.reportError(value, name: name, file: file, function: function, line: line, callStack: callStack)
        }
    }
}

var errorReporters: [ErrorReporter] = []

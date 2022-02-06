import Foundation

func postDump<T>(_ value: T, name: String?, file: String, function: String, line: Int, callStack: CallStack) {
    hookErrorReportersForDump(value, name: name, file: file, function: function, line: line, callStack: callStack)
}

private func hookErrorReportersForDump<T>(_ value: T, name: String?, file: String, function: String, line: Int, callStack: CallStack) {
    
    guard let name = name else {
        return
    }
    guard name.hasSuffix("Failed") || (name.hasSuffix("Error") && name != "standardError") || name == "error" else {
        return
    }
    
    if !UserDefaults.standard.bool(forKey: DefaultsKey.suppressErrorReporting) {
        errorReporters.forEach {
            $0.reportError(value, name: name, file: file, function: function, line: line, callStack: callStack)
        }
    }
}

var errorReporters: [ErrorReporter] = [
    OSLogErrorReporter()
]

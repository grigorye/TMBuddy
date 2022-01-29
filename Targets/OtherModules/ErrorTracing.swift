func postprocessDumpedValue<T>(_ value: T, name: String?, file: String, function: String, line: Int, callStack: CallStack) {
    
    guard let name = name else {
        return
    }
    guard name.hasSuffix("Failed") || name.hasSuffix("Error") || name == "error" else {
        return
    }
    
    reportError(value, name: name, file: file, function: function, line: line, callStack: callStack)
}

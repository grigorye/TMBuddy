func postDump<T>(_ value: T, name: String?, file: StaticString, function: String, line: Int, callStack: CallStack) {
    hookActionTrackersForDump(value, name: name, file: file, function: function, line: line, callStack: callStack)
    hookErrorReportersForDump(value, name: name, file: file, function: function, line: line, callStack: callStack)
}

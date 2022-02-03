protocol ErrorReporter {
    func reportError<T>(_ value: T, name: String, file: String, function: String, line: Int, callStack: CallStack)
}

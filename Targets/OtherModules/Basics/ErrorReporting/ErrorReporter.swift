protocol ErrorReporter {
    func reportError<T>(_ value: T, name: String?, file: StaticString, function: String, line: Int, callStack: CallStack)
}

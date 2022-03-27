protocol ErrorReporter {
    func reportError<T>(_ value: T, name: String?, sourceInfo: SourceInfo)
}

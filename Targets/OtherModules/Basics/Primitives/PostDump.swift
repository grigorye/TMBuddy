func postDump<T>(_ value: T, name: String?, sourceInfo: SourceInfo) {
    hookActionTrackersForDump(value, name: name, sourceInfo: sourceInfo)
    hookErrorReportersForDump(value, name: name, sourceInfo: sourceInfo)
}

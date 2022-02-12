enum PlugInFullDiskAccessCheckpointState {
    case granted
    case denied
    case unresponsive
    case none
}

protocol PlugInFullDiskAccessCheckpointActions {
    func revealExtensionInFinder()
    func openFullDiskAccessPreferences()
}

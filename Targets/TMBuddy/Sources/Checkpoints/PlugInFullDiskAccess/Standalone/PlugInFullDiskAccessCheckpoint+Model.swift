enum PlugInFullDiskAccessCheckpointState {
    case granted
    case denied
    case unresponsive
    case none
}

protocol PlugInFullDiskAccessCheckpointActions: ViewActions {
    func revealExtensionInFinder()
    func openFullDiskAccessPreferences()
}

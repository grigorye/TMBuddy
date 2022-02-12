import AppKit

struct PlugInFullDiskAccessCheckpointActionHandler: PlugInFullDiskAccessCheckpointActions {
    
    func revealExtensionInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([plugInURL!])
    }
    
    func openFullDiskAccessPreferences() {
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!)
    }
}

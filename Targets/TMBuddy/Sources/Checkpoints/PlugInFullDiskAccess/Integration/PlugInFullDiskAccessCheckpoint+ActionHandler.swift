import AppKit

struct PlugInFullDiskAccessCheckpointActionHandler: PlugInFullDiskAccessCheckpointActions, Traceable {
    
    func revealExtensionInFinder() {
        dump((), name: "")
        
        NSWorkspace.shared.activateFileViewerSelecting([plugInURL!])
    }
    
    func openFullDiskAccessPreferences() {
        dump((), name: "")
        
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!)
    }
}

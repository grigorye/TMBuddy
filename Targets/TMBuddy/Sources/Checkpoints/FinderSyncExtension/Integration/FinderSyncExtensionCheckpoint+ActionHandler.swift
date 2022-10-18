import AppKit
import FinderSync

final class FinderSyncExtensionCheckpointActionsHandler: FinderSyncExtensionCheckpointActions, Traceable {
    
    func showExtensionsPreferences() {
        dump((), name: "")
        
        FIFinderSyncController.showExtensionManagementInterface()
    }
    
    func revealAlienInFinder(path: String) {
        dump((), name: "")
        
        NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: path)])
    }
}

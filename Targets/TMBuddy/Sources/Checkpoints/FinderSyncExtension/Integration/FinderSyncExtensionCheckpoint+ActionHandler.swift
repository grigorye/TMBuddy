import AppKit
import FinderSync

class FinderSyncExtensionCheckpointActionsHandler: FinderSyncExtensionCheckpointActions {
    
    func showExtensionsPreferences() {
        FIFinderSyncController.showExtensionManagementInterface()
    }
    
    func revealAlienInFinder(path: String) {
        NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: path)])
    }
}

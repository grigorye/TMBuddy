import AppKit

struct FolderSelectionCheckpointActionsActionHandler: FolderSelectionCheckpointActions {
    
    func selectFolders() {
        selectDisks()
    }
    
    func revokeAccess() {
        processURLs([])
    }
}

private func selectDisks() {
    let panel = NSOpenPanel() ≈ {
        $0.message = "Select all the disks available, to grant the read-only access to \(appName)"
        $0.canChooseFiles = false
        $0.canChooseDirectories = true
        $0.allowsMultipleSelection = true
        $0.directoryURL = URL(fileURLWithPath: "/")
        $0.prompt = "Select"
    }
    
    let response = panel.runModal()
    dump(response, name: "panelResponse")
    
    guard response == NSApplication.ModalResponse.OK else {
        return
    }
    
    let urls = panel.urls
    let existingURLs = resolveBookmarks(sharedDefaults.sandboxedBookmarks ?? [])
    let updatedURLs = Array(Set(urls + existingURLs))
    
    dump((existing: existingURLs.paths, selected: urls.paths, new: updatedURLs.paths), name: "paths")
    
    processURLs(updatedURLs)
}

private let defaults = UserDefaults.standard

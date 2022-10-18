import AppKit

struct FolderSelectionCheckpointActionsActionHandler: FolderSelectionCheckpointActions, Traceable {
    
    func selectFolders() {
        dump((), name: "")
        
        selectDisks()
    }
    
    func revokeAccess() {
        dump((), name: "")
        
        processURLs([])
    }
}

@MainActor
private func selectDisks() {
    let panel = NSOpenPanel() ≈ {
        $0.message = String(localized: "Select all the disks available, to grant the read-only access to \(appName)")
        $0.canChooseFiles = false
        $0.canChooseDirectories = true
        $0.allowsMultipleSelection = true
        $0.directoryURL = URL(fileURLWithPath: "/")
        $0.prompt = String(localized: "Select")
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

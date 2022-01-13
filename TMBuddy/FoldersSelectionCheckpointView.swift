import SwiftUI

struct FoldersSelectionCheckpointView: View {
    
    @ObservedObject var bookmarksCountProvider = BookmarkCountProvider()
    
    var body: some View {
        let bookmarkCount = bookmarksCountProvider.bookmarkCount
        
        CheckpointView(
            title: "Folders selected",
            subtitle: "\(appName) is enabled only in the selected folders (and any folders inside).",
            value: bookmarkCount > 0 ? "\(bookmarkCount)" : "none",
            completed: bookmarkCount > 0
        ) {
            VStack(alignment: .leading) {
                HStack {
                    Button(bookmarkCount > 0 ? "Add More Folders" : "Select Folders") {
                        selectDisks()
                    }
                    if bookmarkCount > 0 {
                        Button(action: revokeAccess) {
                            Text("Clear Selection")
                        }
                    }
                }
            }
        }
    }
}

class BookmarkCountProvider: ObservableObject {
    
    @Published var bookmarkCount: Int = 0
    
    var userDefaultsObserver: UserDefaultsObserver?
    
    init() {
        userDefaultsObserver = .init(defaults: defaults, key: DefaultsKey.scopedSandboxedBookmarks.rawValue, options: [.initial]) { [weak self] change in
            self?.bookmarkCount = defaults.scopedSandboxedBookmarks?.count ?? 0
        }
    }
}

private func revokeAccess() {
    processURLs([])
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

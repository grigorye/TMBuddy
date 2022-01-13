import SwiftUI

class BookmarkCountProvider: ObservableObject {
    
    @Published var bookmarkCount: Int = 0
    
    var userDefaultsObserver: UserDefaultsObserver?
    
    init() {
        userDefaultsObserver = .init(defaults: defaults, key: DefaultsKey.scopedSandboxedBookmarks.rawValue, options: [.initial]) { [weak self] change in
            self?.bookmarkCount = defaults.scopedSandboxedBookmarks?.count ?? 0
        }
    }
}

struct SandboxAccessView: View {
    
    @ObservedObject var bookmarksCountProvider = BookmarkCountProvider()

    var body: some View {
        VStack {
            Button("Grant (Read-Only) Access to Disks…") {
                selectDisks()
            }
            
            Divider().hidden()

            let bookmarkCount = bookmarksCountProvider.bookmarkCount
                        
            if bookmarkCount > 0 {
                HStack {
                    Text("Tracked locations: \(bookmarksCountProvider.bookmarkCount)")
                    if #available(macOS 11.0, *) {
                        Button(action: revokeAccess) {
                            Image(systemName: "xmark.circle.fill")
                        }.buttonStyle(PlainButtonStyle())
                    } else {
                        Button(action: revokeAccess) {
                            Text("Revoke")
                        }
                    }
                }
            }
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

private func processURLs(_ urls: [URL]) {
    dump(urls.paths, name: "paths")
    
    try! saveScopedSandboxedBookmark(urls: urls, in: defaults)
    try! saveSandboxedBookmark(urls: urls, in: sharedDefaults)
    
    do {
        let succeeded = sharedDefaults.synchronize()
        dump(succeeded, name: "sharedDefaultsSyncSucceeded")
    }
}

func saveScopedSandboxedBookmark(urls: [URL], in defaults: UserDefaults) throws {
    let bookmarks: [Data] = try urls.map { url in
        let bookmark = try url.bookmarkData(options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess])
        dump((path: url.path, bookmark), name: "bookmark")
        return bookmark
    }
    
    defaults.scopedSandboxedBookmarks = bookmarks
}

func saveSandboxedBookmark(urls: [URL], in defaults: UserDefaults) throws {
    let bookmarks: [Data] = try urls.map { url in
        let bookmark = try url.bookmarkData(options: [])
        dump((path: url.path, bookmark), name: "bookmark")
        return bookmark
    }
    
    defaults.sandboxedBookmarks = bookmarks
}

private let defaults = UserDefaults()

extension Array where Element == URL {
    var paths: [String] {
        map { $0.path }
    }
}

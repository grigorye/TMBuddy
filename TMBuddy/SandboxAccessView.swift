import SwiftUI

struct SandboxAccessView: View {
    
    var body: some View {
        Button("Grant (Read-Only) Access to Disks…") {
            selectDisks()
        }
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
    dump(urls, name: "urlsSelected")
    
    processURLs(urls)
}

private func processURLs(_ urls: [URL]) {
    dump(urls, name: "urls")
    
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
        dump((url.path, bookmark), name: "bookmark")
        return bookmark
    }
    
    defaults.scopedSandboxedBookmarks = bookmarks
}

func saveSandboxedBookmark(urls: [URL], in defaults: UserDefaults) throws {
    let bookmarks: [Data] = try urls.map { url in
        let bookmark = try url.bookmarkData(options: [])
        dump((url.path, bookmark), name: "bookmark")
        return bookmark
    }
    
    defaults.sandboxedBookmarks = bookmarks
}

private let defaults = UserDefaults()

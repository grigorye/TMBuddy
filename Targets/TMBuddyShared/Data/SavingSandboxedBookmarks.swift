import Foundation

func saveScopedSandboxedBookmark(urls: [URL], in defaults: UserDefaults) {
    let bookmarks: [Data] = urls.compactMap { url in
        do {
            let bookmark = try url.bookmarkData(options: [.withSecurityScope])
            dump((path: url.path, bookmark), name: "bookmark")
            return bookmark
        } catch {
            dump((error: error, path: url.path), name: "bookmarkDataFailed")
            return nil
        }
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

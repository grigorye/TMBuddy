import Foundation

class SandboxedBookmarksResolver {
    
    let observer = UserDefaultsObserver(defaults: sharedDefaults, key: DefaultsKey.sandboxedBookmarks.rawValue, options: [.new, .initial]) { change in

        guard let changeBookmarks = change![.newKey] as? [Data]? else {
            dump(change, name: "invalidChange")
            fatalError("Invalid change, expecting Data?")
        }
        
        guard let bookmarks = changeBookmarks else {
            return
        }
        for bookmark in bookmarks {
            do {
                var isStale = false
                let url = try URL(resolvingBookmarkData: bookmark, bookmarkDataIsStale: &isStale)
                dump((url, isStale: isStale), name: "resolvedSandboxedBookmark")
            } catch {
                dump((error, bookmark: bookmark), name: "sandboxBookmarkResolutionFailed")
            }
        }
    }
}

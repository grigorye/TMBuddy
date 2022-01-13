import Foundation

class SandboxedBookmarksResolver {
    
    init(handleResolvedBookmarkURLs: @escaping ([URL]) -> Void) {
        observer = UserDefaultsObserver(defaults: sharedDefaults, key: DefaultsKey.sandboxedBookmarks.rawValue, options: [.new, .initial]) { change in
            
            guard let changeBookmarks = change![.newKey] as? [Data]? else {
                dump(change, name: "invalidChange")
                fatalError("Invalid change, expecting Data?")
            }
            
            guard let bookmarks = changeBookmarks else {
                return
            }
            
            let resolvedBookmarkURLs = resolveBookmarks(bookmarks)
            handleResolvedBookmarkURLs(resolvedBookmarkURLs)
        }
    }
    
    private let observer: UserDefaultsObserver
}

func resolveBookmarks(_ bookmarks: [Data]) -> [URL] {
    bookmarks.compactMap { bookmark in
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmark, bookmarkDataIsStale: &isStale)
            dump((url, isStale: isStale), name: "resolvedSandboxedBookmark")
            return url
        } catch {
            dump((error, bookmark: bookmark), name: "sandboxBookmarkResolutionFailed")
            return nil
        }
    }
}

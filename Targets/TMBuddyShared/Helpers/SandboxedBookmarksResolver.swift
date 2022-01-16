import Foundation

class SandboxedBookmarksResolver {
    
    init(handleResolvedBookmarkURLs: @escaping ([URL]) -> Void) {
        self.handleResolvedBookmarkURLs = handleResolvedBookmarkURLs
        
        observer = UserDefaultsObserver(
            defaults: sharedDefaults,
            key: DefaultsKey.sandboxedBookmarks.rawValue,
            options: [.new, .initial]
        ) { [weak self] change in
            self?.observeSandboxedBookmarks(change)
        }
    }
    
    func observeSandboxedBookmarks(_ change: [NSKeyValueChangeKey : Any]?) {
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
    
    private var observer: UserDefaultsObserver?
    private let handleResolvedBookmarkURLs: ([URL]) -> Void
}

func resolveBookmarks(_ bookmarks: [Data], options: URL.BookmarkResolutionOptions = []) -> [URL] {
    bookmarks.compactMap { bookmark in
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmark, options: options, bookmarkDataIsStale: &isStale)
            dump((url.path, options: options, isStale: isStale), name: "resolvedBookmark")
            return url
        } catch {
            dump((error, options: options, bookmark: bookmark), name: "bookmarkResolutionFailed")
            return nil
        }
    }
}

extension SandboxedBookmarksResolver: Traceable {}

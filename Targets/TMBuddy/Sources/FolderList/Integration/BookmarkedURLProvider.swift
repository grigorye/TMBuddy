import SwiftUI

class BookmarkedURLProvider: ObservableObject {
    @Published var urls: [URL] = []
    
    private var retained: [Any] = []
    
    init() {
        let bookmarksResolver = SandboxedBookmarksResolver { [weak self] urls in
            guard let self else { assertionFailure(); return }
            self.urls = urls
        }
        retained += [bookmarksResolver]
    }
}

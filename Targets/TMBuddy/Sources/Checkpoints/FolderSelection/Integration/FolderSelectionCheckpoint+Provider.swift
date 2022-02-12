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

private let defaults = UserDefaults.standard

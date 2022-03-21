import SwiftUI

class BoolUserDefaultsProvider: ObservableObject {
    
    @Published var value: Bool = false
    
    var userDefaultsObserver: UserDefaultsObserver?
    
    deinit {
        _ = ()
    }
    init(key: String) {
        userDefaultsObserver = .init(defaults: defaults, key: key, options: [.initial]) { [weak self] change in
            self?.value = defaults.bool(forKey: key)
        }
    }
}

private let defaults = UserDefaults.standard

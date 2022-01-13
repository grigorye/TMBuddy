import Foundation

extension UserDefaults {
    
    var sandboxedBookmarks: [Data]? {
        get {
            array(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }

    static private let key = DefaultsKey.sandboxedBookmarks
}

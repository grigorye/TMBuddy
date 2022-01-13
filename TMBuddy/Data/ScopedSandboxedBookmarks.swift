import Foundation

extension UserDefaults {
    
    var scopedSandboxedBookmarks: [Data]? {
        get {
            array(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }
    
    static private let key = DefaultsKey.scopedSandboxedBookmarks
}

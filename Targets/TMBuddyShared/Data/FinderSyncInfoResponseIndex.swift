import Foundation

extension UserDefaults {
    
    static private let key = DefaultsKey.finderSyncInfoResponseIndex
    
    var finderSyncInfoResponseIndex: Int {
        get {
            assert(Self.key.rawValue == #function)
            return integer(forKey: Self.key)
        }
        set {
            assert(Self.key.rawValue == #function)
            set(newValue, forKey: Self.key)
        }
    }
}

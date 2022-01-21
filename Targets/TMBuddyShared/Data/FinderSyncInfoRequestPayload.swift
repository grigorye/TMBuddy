import Foundation

extension UserDefaults {
        
    static private let key = DefaultsKey.finderSyncInfoRequestPayload

    var finderSyncInfoRequestPayload: Data? {
        get {
            assert(Self.key.rawValue == #function)
            return data(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }
}

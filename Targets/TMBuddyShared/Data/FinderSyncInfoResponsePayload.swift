import Foundation

extension UserDefaults {
        
    static private let key = DefaultsKey.finderSyncInfoResponsePayload

    var finderSyncInfoResponsePayload: Data? {
        get {
            assert(Self.key.rawValue == #function)
            return data(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }
}

import Foundation

extension UserDefaults {
    
    var analyticsEnabled: Bool {
        get {
            bool(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }
    
    static private let key = DefaultsKey.analyticsEnabled
}

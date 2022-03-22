import Foundation

extension UserDefaults {
    
    var actionTrackingEnabled: Bool {
        get {
            bool(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }
    
    static private let key = DefaultsKey.forceActionTracking
}

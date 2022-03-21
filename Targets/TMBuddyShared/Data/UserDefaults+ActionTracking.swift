import Foundation

extension UserDefaults {
    
    var actionTrackingEnabled: Bool {
        get {
            !actionTrackingSuppressed
        }
        set {
            actionTrackingSuppressed = !newValue
        }
    }
    
    var actionTrackingSuppressed: Bool {
        get {
            bool(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }
    
    static private let key = DefaultsKey.suppressActionTracking
}

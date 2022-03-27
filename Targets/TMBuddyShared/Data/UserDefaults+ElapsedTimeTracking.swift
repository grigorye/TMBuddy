import Foundation

extension UserDefaults {
    
    var elapsedTimeTrackingEnabled: Bool {
        get {
            bool(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }
    
    static private let key = DefaultsKey.elapsedTimeTrackingEnabled
}

import Foundation

extension UserDefaults {
    
    var activityTrackingEnabled: Bool {
        get {
            bool(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }
    
    static private let key = DefaultsKey.activityTrackingEnabled
}

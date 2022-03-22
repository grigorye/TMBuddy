import Foundation

extension UserDefaults {
    
    var errorReportingEnabled: Bool {
        get {
            bool(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }
    
    static private let key = DefaultsKey.forceErrorReporting
}

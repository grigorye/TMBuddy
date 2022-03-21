import Foundation

extension UserDefaults {
    
    var errorReportingEnabled: Bool {
        get {
            !errorReportingSuppressed
        }
        set {
            errorReportingSuppressed = !newValue
        }
    }
    
    var errorReportingSuppressed: Bool {
        get {
            bool(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }
    
    static private let key = DefaultsKey.suppressErrorReporting
}

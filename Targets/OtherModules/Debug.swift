import Foundation

var debug: Bool {
    UserDefaults.standard.bool(forKey: DefaultsKey.debug)
}

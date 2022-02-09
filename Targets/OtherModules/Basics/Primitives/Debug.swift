import Foundation

var debug: Bool {
    UserDefaults.standard.bool(forKey: DefaultsKey.debug)
}

func debug(_ block: () -> Void) {
    if debug {
        block()
    }
}

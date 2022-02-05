import Foundation

@objc protocol TMUtilHelperXPC {
    func ping()
    func setExcludedByPath(_ value: Bool, paths: [String])
}

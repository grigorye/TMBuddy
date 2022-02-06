import Foundation

@objc protocol CommonHelperXPC {
    func pingAsync(_: @escaping (Bool) -> Void)
    func versionAsync(_: @escaping (String) -> Void)
    func crashAsync(_: @escaping (Bool) -> Void)
}

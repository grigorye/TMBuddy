import Foundation

@objc protocol CommonHelperXPC {
    func pingAsync(_: @Sendable @escaping (Bool) -> Void)
    func versionAsync(_: @Sendable @escaping (String) -> Void)
    func crashAsync(_: @Sendable @escaping (Bool) -> Void)
    func checkSanityAsync(writablePath: String, readOnlyPath: String, reply: @Sendable @escaping (Error?) -> Void)
    func postInstallAsync(sourceBundlePath: String, reply: @Sendable @escaping (Error?) -> Void)
    func postInstallNeededAsync(sourceBundlePath: String, reply: @Sendable @escaping (Error?, Bool) -> Void)
}

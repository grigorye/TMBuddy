import Foundation

@objc protocol CommonHelperXPC {
    func pingAsync(_: @escaping (Bool) -> Void)
    func versionAsync(_: @escaping (String) -> Void)
    func crashAsync(_: @escaping (Bool) -> Void)
    func checkSanityAsync(writablePath: String, readOnlyPath: String, reply: @escaping (Error?) -> Void)
    func postInstallAsync(sourceBundlePath: String, reply: @escaping (Error?) -> Void)
    func postInstallNeededAsync(sourceBundlePath: String, reply: @escaping (Error?, Bool) -> Void)
}

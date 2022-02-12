import Foundation

let postInstallHelperSourceBundlePath: String = {
    let copyURL = URL(fileURLWithPath: "/Users/Shared/TMBuddy/TMBuddy.app")
    try? FileManager.default.createDirectory(
        at: copyURL.deletingLastPathComponent(),
        withIntermediateDirectories: true
    )
    try? FileManager.default.removeItem(at: copyURL)
    try! FileManager.default.copyItem(at: Bundle.main.bundleURL, to: copyURL)
    return copyURL.path
}()

import Foundation

let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

var plugInHostConnectionVersion: String {
    guard let bundleVersion = bundleVersion else {
        return srcRoot
    }
    guard bundleVersion != "Local" else {
        return srcRoot
    }
    return bundleVersion
}

import Foundation

var plugInHostConnectionVersion: String {
    guard let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
        return srcRoot
    }
    guard bundleVersion != "Local" else {
        return srcRoot
    }
    return bundleVersion
}

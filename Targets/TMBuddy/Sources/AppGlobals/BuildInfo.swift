import SwiftUI

let enforcedBuildInfoString: String? = nil

var buildInfoString: String {
    enforcedBuildInfoString ?? {
        let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        if bundleVersion == "Local" {
            return (srcRoot as NSString).lastPathComponent
        } else {
            return "\(bundleVersion)"
        }
    }()
}

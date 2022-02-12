import Foundation

func mainWindowTitle() -> String {
    if isAppDistributedViaAppStore || UserDefaults.standard.bool(forKey: DefaultsKey.forceAppStoreLikeWindowTitle.rawValue) {
        return appName
    } else {
        return "\(appName) (\(buildInfoString))"
    }
}

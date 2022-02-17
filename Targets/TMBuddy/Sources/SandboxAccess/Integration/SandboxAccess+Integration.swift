import SwiftUI

extension SandboxAccessView {
    
    static func new() -> some View {
        ObservableWrapperView(
            DebugFlagProvider()
        ) { debugFlag in
            Self(state: .init(
                showPostSMJobBless: shouldShowSMJobBless,
                showPostInstall: shouldShowPostInstall,
                showDebug: debugFlag.debugIsEnabled
            )) ≈ {
                $0.actions = ()
            }
        }
    }
}

private let shouldShowSMJobBless: Bool = {
    let shouldShow = isSandboxed() == false
    dump(shouldShow, name: "shouldShowSMJobBless")
    return shouldShow
}()

private let shouldShowPostInstall: Bool = {
    if #available(macOS 11.0, *), defaults.bool(forKey: DefaultsKey.forcePostInstallCheckpoint) != true {
        return false
    } else {
        return true
    }
}()

private let defaults = UserDefaults.standard

func isSandboxed() -> Bool {
    let bundleURL = Bundle.main.bundleURL
    var staticCode: SecStaticCode!
    let kSecCSDefaultFlags = SecCSFlags()
    
    guard SecStaticCodeCreateWithPath(bundleURL as CFURL, kSecCSDefaultFlags, &staticCode) == errSecSuccess else {
        return false
    }
    guard SecStaticCodeCheckValidityWithErrors(staticCode!, SecCSFlags(rawValue: kSecCSBasicValidateOnly), nil, nil) == errSecSuccess else {
        return false
    }
    
    let appSandbox = "entitlement[\"com.apple.security.app-sandbox\"] exists"
    var sandboxRequirement: SecRequirement!
    
    guard SecRequirementCreateWithString(appSandbox as CFString, kSecCSDefaultFlags, &sandboxRequirement) == errSecSuccess else {
        return false
    }
    guard SecStaticCodeCheckValidityWithErrors(staticCode, SecCSFlags(rawValue: kSecCSBasicValidateOnly), sandboxRequirement, nil) == errSecSuccess else {
        return false
    }
    return true
}

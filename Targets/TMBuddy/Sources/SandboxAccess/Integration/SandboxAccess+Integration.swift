import SwiftUI

extension SandboxAccessView {
    
    static func new() -> some View {
        ObservableWrapperView(
            DebugFlagProvider()
        ) { debugFlag in
            Self(state: .init(
                showPostInstall: shouldShowPostInstall,
                showDebug: debugFlag.debugIsEnabled
            )) ≈ {
                $0.actions = ()
            }
        }
    }
}

private let shouldShowPostInstall: Bool = {
    if #available(macOS 11.0, *), defaults.bool(forKey: DefaultsKey.forcePostInstallCheckpoint) != true {
        return false
    } else {
        return true
    }
}()

private let defaults = UserDefaults.standard

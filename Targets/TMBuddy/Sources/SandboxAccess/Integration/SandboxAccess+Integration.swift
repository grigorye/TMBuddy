import SwiftUI
import Blessed

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
    do {
        let shouldShow = try NSApp.isSandboxed() == false
        dump(shouldShow, name: "shouldShowSMJobBless")
        return shouldShow
    } catch {
        dump(error, name: "isSandboxedFailed")
        return true
    }
}()

private let shouldShowPostInstall: Bool = {
    if #available(macOS 11.0, *), defaults.bool(forKey: DefaultsKey.forcePostInstallCheckpoint) != true {
        return false
    } else {
        return true
    }
}()

private let defaults = UserDefaults.standard

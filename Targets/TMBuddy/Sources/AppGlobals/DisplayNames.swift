import Foundation

private let fileManager = FileManager.default

@MainActor var enforcedAppName: String? { defaultEnforcedAppName }

@MainActor var appName: String {
    enforcedAppName ?? {
        fileManager.displayName(atPath: Bundle.main.bundlePath)
    }()
}

let finderName = fileManager.displayName(atPath: "/System/Library/CoreServices/Finder.app")

@MainActor var plugInName: String {
    guard let plugInURL = plugInURL else {
        dump((), name: "unknownPlugInURL")
        return plugInFallbackName
    }
    return fileManager.displayName(atPath: plugInURL.path)
}

@MainActor private var plugInFallbackName: String {
    "\(appName) Finder Extension"
}

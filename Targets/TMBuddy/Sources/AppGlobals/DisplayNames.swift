import Foundation

private let fileManager = FileManager.default

@MainActor var enforcedAppName: String? { defaultEnforcedAppName }

@MainActor var appName: String {
#if !GE_SNAPSHOT_TESTING
    fileManager.displayName(atPath: Bundle.main.bundlePath)
#else
    "TMBuddy"
#endif
}

let finderName = fileManager.displayName(atPath: "/System/Library/CoreServices/Finder.app")

@MainActor var plugInName: String {
#if !GE_SNAPSHOT_TESTING
    guard let plugInURL = plugInURL else {
        dump((), name: "unknownPlugInURL")
        return plugInFallbackName
    }
    return fileManager.displayName(atPath: plugInURL.path)
#else
    return "\(appName) Finder Extension"
#endif
}

@MainActor private var plugInFallbackName: String {
    "\(appName) Finder Extension"
}

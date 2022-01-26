import Foundation

let fileManager = FileManager.default

let appName = fileManager.displayName(atPath: Bundle.main.bundlePath)
let finderName = fileManager.displayName(atPath: "/System/Library/CoreServices/Finder.app")

var plugInName: String {
    guard let plugInURL = plugInURL else {
        dump((), name: "unknownPlugInURL")
        return plugInFallbackName
    }
    return fileManager.displayName(atPath: plugInURL.path)
}

private var plugInFallbackName: String {
    "\(appName) Finder Extension"
}

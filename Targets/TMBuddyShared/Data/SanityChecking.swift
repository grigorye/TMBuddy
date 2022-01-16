import Foundation

func checkSanity() {
    reportPaths()
    reportTimeMachinePermissions()
    reportDefaults()
}

func reportPaths() {
    dump(Bundle.main.bundlePath, name: "mainBundlePath")

    dump(FileManager.default.homeDirectoryForCurrentUser(ignoringSandbox: true).path, name: "homeDirectoryForCurrentUser")
    dump(FileManager.default.homeDirectory(forUser: "Guest", ignoringSandbox: true)?.path, name: "homeDirectoryForGuestUser")
}

func reportDefaults() {
    dump(filteredDictionaryFor(defaults: .standard), name: "defaults", maxDepth: 2, maxItems: .max)
    dump(filteredDictionaryFor(defaults: sharedDefaults), name: "sharedDefaults", maxDepth: 2, maxItems: .max)
}

func filteredDictionaryFor(defaults: UserDefaults) -> [String: Any] {
    let dictionaryRep = defaults.dictionaryRepresentation()
    let keys = DefaultsKey.allCases.map { $0.rawValue }
    let filtered = dictionaryRep.filter { keys.contains($0.key) }
    return filtered
}

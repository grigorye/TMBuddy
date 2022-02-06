import Foundation

func checkSanity() {
    reportPaths()
    reportTimeMachinePermissions()
    reportDefaults()
    reportTMUtilHelperStatus()
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

func reportTMUtilHelperStatus() {
    let testPath = "/tmp/TMBuddy-Excluded-ByPath.txt"
    let testURL = URL(fileURLWithPath: testPath)
    let tmUtilCheck = Task {
        let version = try await TMUtilPrivileged().version()
        dump(version, name: "version")
        try await TMUtilPrivileged().setExcludedByPath(true, urls: [testURL])
    }
    Task {
        let result = await tmUtilCheck.result
        dump((result, testPath: testPath), name: "tmUtilCheckResult")
    }
}

import Foundation

func checkSanity() {
    reportPaths()
    reportTimeMachinePermissions()
    reportDefaults()
    checkTMUtilHelperSanity()
    checkTMUtilHelperTildeHandling()
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

func checkTMUtilHelperSanity() {
    let task = Task {
        let version = try await TMUtilPrivileged().version()
        dump(version, name: "version")
        try await TMUtilPrivileged().checkSanity()
    }
    Task {
        let result = await task.result
        dump(result, name: "result")
    }
}

func checkTMUtilHelperTildeHandling() {
    let moduleName = Bundle.main.executableURL!.lastPathComponent
    let testPath = ("~/\(moduleName)-Test/Excluded-ByPath.txt" as NSString).expandingTildeInPath(ignoringSandbox: true)
    let testURL = URL(fileURLWithPath: testPath)
    let task = Task {
        try await TMUtilPrivileged().setExcluded(true, privilege: .fixedPath, urls: [testURL])
        let tildeHandlingIsSane = TimeMachinePathFilter().isExcluded(testURL)
        dump(tildeHandlingIsSane, name: "tildeHandlingIsSane")
        if tildeHandlingIsSane == false {
            enum Error: Swift.Error {
                case tildeHandlingIsNotSane
            }
            throw Error.tildeHandlingIsNotSane
        }
    }
    Task {
        let result = await task.result
        switch result {
        case let .failure(error):
            dump(error, name: "tildeHandlingCheckFailed")
        case .success:
            dump((), name: "tildeHandlingCheckSucceeded")
        }
    }
}

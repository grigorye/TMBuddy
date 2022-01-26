import Foundation

func reportTimeMachinePermissions() {
    dumpTimeMachinePreferences()
}

func timeMachinePreferencesAccessError() -> Error? {
    do {
        _ = try Data(contentsOf: URL(fileURLWithPath: "/Library/Preferences/com.apple.TimeMachine.plist"))
        return nil
    } catch {
        return error
    }
}

func dumpTimeMachinePreferences() {
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: "/Library/Preferences/com.apple.TimeMachine.plist"))
        let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        
        guard let plist = plist as? [String: Any] else {
            dump((), name: "plistUnreadable")
            return
        }
        
        dump(Array(plist.keys), name: "keys", maxDepth: 1)
        
        if let skipPaths = plist[TimeMachineUserDefaultsKey.skipPaths.rawValue] {
            dump(skipPaths, name: "skipPaths", maxDepth: 1, maxItems: .max)
        } else {
            dump((), name: "skipPathsUnreadable")
        }
        if let excludedVolumeUUIDs = plist[TimeMachineUserDefaultsKey.excludedVolumeUUIDs.rawValue] {
            dump(excludedVolumeUUIDs, name: "excludedVolumeUUIDs", maxDepth: 1, maxItems: .max)
        } else {
            dump((), name: "excludedVolumeUUIDsUnreadable")
        }
    } catch {
        dump(error, name: "error")
    }
}

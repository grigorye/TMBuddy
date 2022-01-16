import Foundation

func reportTimeMachinePermissions() {
    dumpTimeMachinePreferences()
}

func dumpTimeMachinePreferences() {
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: "/Library/Preferences/com.apple.TimeMachine.plist"))
        let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        
        guard let plist = plist as? [String: Any] else {
            dump("plistUnreadable")
            return
        }
        
        dump(Array(plist.keys), name: "keys", maxDepth: 1)
        
        if let skipPaths = plist[TimeMachineUserDefaultsKey.skipPaths.rawValue] {
            dump(skipPaths, name: "skipPaths", maxDepth: 1, maxItems: .max)
        } else {
            dump("skipPathsUnreadable")
        }
        if let excludedVolumeUUIDs = plist[TimeMachineUserDefaultsKey.excludedVolumeUUIDs.rawValue] {
            dump(excludedVolumeUUIDs, name: "excludedVolumeUUIDs", maxDepth: 1, maxItems: .max)
        } else {
            dump("excludedVolumeUUIDsUnreadable")
        }
    } catch {
        dump(error)
    }
}

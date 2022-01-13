import Foundation

func isFullDiskAccessGranted() -> Bool {
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: "/Library/Preferences/com.apple.TimeMachine.plist"))
        _ = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        return true
    } catch {
        dump(error)
        return false
    }
}

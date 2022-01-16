import Foundation

var timeMachineUserDefaults: UserDefaults {
    .init(suiteName: "com.apple.TimeMachine")!
}

enum TimeMachineUserDefaultsKey: String {
    case skipPaths = "SkipPaths"
    case excludedVolumeUUIDs = "ExcludedVolumeUUIDs"
}

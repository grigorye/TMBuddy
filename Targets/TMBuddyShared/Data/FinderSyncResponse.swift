struct FinderSyncInfoResponse: Codable {
    var version: String
    var timeMachinePreferencesAccess: TimeMachinePreferencesAccess
}

enum TimeMachinePreferencesAccess: Codable {
    case granted
    case denied(String)
}

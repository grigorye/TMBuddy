struct FinderSyncInfoResponseHeader: Codable {
    var index: Int
    var version: String
}

struct FinderSyncInfoResponse: Codable {
    var index: Int
    var version: String
    
    var info: Info
    
    enum Info: Codable {
        case checkStatus(CheckStatusResult)
    }
}

enum CheckStatusResult: Codable {
    case timeMachinePreferencesAccess(TimeMachinePreferencesAccess)
}

enum TimeMachinePreferencesAccess: Codable {
    case granted
    case denied(String)
}

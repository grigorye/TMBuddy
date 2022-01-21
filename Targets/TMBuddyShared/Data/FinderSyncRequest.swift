struct FinderSyncInfoRequestHeader: Codable {
    var index: Int
    var version: String
}

struct FinderSyncInfoRequest: Codable {
    var index: Int
    var version: String
    
    var command: Command
    
    enum Command: Codable {
        case checkStatus
    }
}

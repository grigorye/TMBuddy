struct FinderSyncInfoResponseHeader: Codable {
    var index: Int
    var version: String
    var requestHeader: FinderSyncInfoRequestHeader
    var info: FinderSyncInfoResponseInfo
}

struct FinderSyncInfoResponseHeaderWithFailure: Codable {
    var index: Int
    var version: String
    var requestHeader: FinderSyncInfoRequestHeader
    var info: FinderSyncInfoResponseInfo
    var result: FinderSyncInfoResponseHeaderFailureResult
}

enum FinderSyncInfoResponseHeaderFailureResult: Codable {
    case failure(InfoFailure)
    case success

    enum InfoFailure: Codable {
        case alienRequest
        case requestDecodingFailed
    }
}

struct FinderSyncInfoResponseInfo: Codable {
    let plugInPath: String
}

struct FinderSyncInfoResponse: Codable {
    var index: Int
    var version: String
    var requestHeader: FinderSyncInfoRequestHeader
    var info: FinderSyncInfoResponseInfo

    var result: Result
    
    typealias InfoFailure = FinderSyncInfoResponseHeaderFailureResult.InfoFailure
    
    enum Result: Codable {
        case failure(InfoFailure)
        case success(InfoSuccess)
        
        enum InfoSuccess: Codable {
            case checkStatus(CheckStatusResult)
        }
    }
}

enum CheckStatusResult: Codable {
    case timeMachinePreferencesAccess(TimeMachinePreferencesAccess)
}

enum TimeMachinePreferencesAccess: Codable {
    case granted
    case denied(String)
}

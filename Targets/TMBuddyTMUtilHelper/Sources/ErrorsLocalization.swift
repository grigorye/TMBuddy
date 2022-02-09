import Foundation

extension TMUtilError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case let .fullDiskAccessMissingForSkipPaths(_, addition: addition):
            return accountingFailureReason(
                addition
                ? "Could not exclude paths from Time Machine backup."
                : "Could not add paths back to Time Machine backup."
            )
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .fullDiskAccessMissingForSkipPaths:
            return "To allow this operation, select Full Disk Access in the Privacy tab of the Security & Privacy preference pane, and add \(Bundle.main.executablePath!) to the list of applications which are allowed Full Disk Access."
        }
    }
}

extension LocalizedError {
    
    func accountingFailureReason(_ message: String) -> String {
        guard let failureReason = failureReason else {
            return message
        }
        return String(format: "%@ %@", message, failureReason)
    }
}

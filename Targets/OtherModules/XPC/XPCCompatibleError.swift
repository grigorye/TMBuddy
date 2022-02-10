import Foundation

//
// A partial remedy for Swift.Error losing every Swift specific bit of information when transported over XPC.
//
protocol XPCCompatibleError: CustomNSError {}

extension XPCCompatibleError where Self: LocalizedError {
    
    var errorUserInfo: [String : Any] {
        [String : Any]() ≈ {
            if let value = errorDescription {
                $0[NSLocalizedDescriptionKey] = value
            } else {
                $0[NSLocalizedDescriptionKey] = "\(self)"
            }
            if let value = failureReason {
                $0[NSLocalizedFailureReasonErrorKey] = value
            }
            if let value = recoverySuggestion {
                $0[NSLocalizedRecoverySuggestionErrorKey] = value
            }
        }
    }
}

extension XPCCompatibleError {
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: "\(self)"]
    }
}

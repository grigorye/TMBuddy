import Foundation

let isAppDistributedViaAppStore: Bool = {
    guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
        return false
    }
    do {
        return try appStoreReceiptURL.checkResourceIsReachable()
    } catch {
        dump(error, name: "expectedError")
        return false
    }
}()

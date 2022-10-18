import Foundation

@MainActor var enforcedIsAppDistributedViaAppStore: Bool? { defaultEnforcedIsAppDistributedViaAppStore }

@MainActor var isAppDistributedViaAppStore: Bool {
    enforcedIsAppDistributedViaAppStore ?? {
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
}

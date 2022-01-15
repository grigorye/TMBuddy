import Foundation

protocol TMStatusProvider {
    func statusForItem(_ url: URL) async throws -> TMStatus
}

extension DirectLookupBasedStatusProvider: TMStatusProvider {}
extension TMUtilBasedStatusProvider: TMStatusProvider {}

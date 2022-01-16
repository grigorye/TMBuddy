import Foundation

protocol TMStatusProvider {
    func statusForItem(_ url: URL) async throws -> TMStatus
}

extension DirectLookupBasedStatusProvider: TMStatusProvider {}
extension TMUtilBasedStatusProvider: TMStatusProvider {}

var statusProvider: TMStatusProvider {
    UserDefaults.standard.bool(forKey: DefaultsKey.forceTMUtilBasedStatusProvider)
    ? TMUtilBasedStatusProvider()
    : DirectLookupBasedStatusProvider()
}

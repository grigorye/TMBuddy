import Foundation

class TMUtilBasedStatusProvider {

    func statusForItem(_ url: URL) async throws -> TMStatus {
        let url = url.resolvingSymlinksInPath()
        let tmUtilController = TMUtilLauncher()
        do {
            let tmUtilStatuses = try await tmUtilController.isExcluded(urls: [url])
            guard let tmUtilStatus = tmUtilStatuses[url] else {
                dump((url: url.path, statuses: tmUtilStatuses), name: "matchFailure")
                return .unknown
            }
            let status: TMStatus = tmUtilStatus ? .excluded : .included
            dump((status, item: url.path), name: "status")
            return status
        } catch {
            dump((error, url: url), name: "queryStatusFailure")
            return .unknown
        }
    }
}

extension TMUtilBasedStatusProvider: Traceable {}

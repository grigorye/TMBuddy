import Foundation

struct ExtendedAttributesBackupController {
    
    func excludedBasedOnMetadata(_ url: URL) -> Bool {
        do {
            return try url.resourceValues(forKeys: [.isExcludedFromBackupKey]).isExcludedFromBackup!
        } catch {
            dump((error, path: url.path), name: "urlResourceValueForIsExcludedFromBackupFailed")
            return false
        }
    }
    
    func setExcluded(_ excluded: Bool, urls: [URL]) async throws {
        dump((excluded, paths: urls.map { $0.path }), name: "excluded")
        
        let resourceValues = URLResourceValues() ≈ {
            $0.isExcludedFromBackup = excluded
        }
        
        for url in urls {
            do {
                _ = try url ≈ {
                    try $0.setResourceValues(resourceValues)
                }
            } catch {
                dump((error, excluded: excluded, path: url.path), name: "urlSetResourceValueForIsExcludedFromBackupFailed")
                throw error
            }
        }
    }
}

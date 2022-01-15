import Foundation

class DirectLookupBasedStatusProvider {
    
    func statusForItem(_ url: URL) async throws -> TMStatus {
        guard (try? volumeFilter.isExcluded(url)) == false else {
            return .excluded
        }
        guard pathFilter.isExcluded(url) == false else {
            return .excluded
        }
        guard metadataFilter.isExcluded(url) == false else {
            return .excluded
        }
        return .included
    }
    
    let pathFilter = TimeMachinePathFilter()
    let volumeFilter = TimeMachineVolumeFilter()
    let metadataFilter = BackupMetadataFilter()
}
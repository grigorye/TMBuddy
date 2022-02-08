import Foundation

class DirectLookupBasedStatusProvider {
    
    func statusForItem(_ url: URL) throws -> TMStatus {
        guard metadataReader.excludedBasedOnMetadata(url) == false else {
            return .stickyExcluded
        }
        guard pathFilter.skipPaths.contains(url.path) == false else {
            return .pathExcluded
        }
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

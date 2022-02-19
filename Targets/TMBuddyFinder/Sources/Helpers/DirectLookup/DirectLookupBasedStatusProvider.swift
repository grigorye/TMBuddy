import Foundation

class DirectLookupBasedStatusProvider {
    
    func statusForItem(_ url: URL) throws -> TMStatus {
        guard metadataReader.excludedBasedOnMetadata(url) == false else {
            return .stickyExcluded
        }
        guard pathFilter.skipPaths.contains(url.path) == false else {
            return .pathExcluded
        }
        guard unsupportedVolumeFilter.isExcluded(url) == false else {
            if try url.isVolume() {
                return .unsupportedVolume
            } else {
                return .parentExcluded
            }
        }
        guard volumeFilter.isExcluded(url) == false else {
            if try url.isVolume() {
                return .excludedVolume
            } else {
                return .parentExcluded
            }
        }
        guard pathFilter.isExcluded(url) == false else {
            return .parentExcluded
        }
        guard metadataFilter.isExcluded(url) == false else {
            return .parentExcluded
        }
        return .included
    }
    
    let pathFilter = TimeMachinePathFilter()
    let volumeFilter = TimeMachineVolumeFilter()
    let metadataFilter = BackupMetadataFilter()
    let unsupportedVolumeFilter = UnsupportedVolumeFilter()
}

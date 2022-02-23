import Foundation

class DirectLookupBasedStatusProvider {
    
    func isPathExcluded(_ url: URL) -> Bool {
        pathFilter.skipPaths.contains(url.path)
    }
    
    func isVolumeExcluded(_ url: URL) -> Bool {
        assert(url.isVolume())
        guard let volumeUUID = url.volumeUUID() else {
            dump(url.path, name: "volumeUUIDFailed")
            return false
        }
        return volumeFilter.excludedVolumeUUIDs.contains(volumeUUID)
    }
    
    func isStickyExcluded(_ url: URL) throws -> Bool {
        metadataReader.excludedBasedOnMetadata(url)
    }
    
    func statusForItem(_ url: URL) throws -> TMStatus {
        guard metadataReader.excludedBasedOnMetadata(url) == false else {
            return .stickyExcluded
        }
        guard pathFilter.skipPaths.contains(url.path) == false else {
            return .pathExcluded
        }
        guard unsupportedVolumeFilter.isExcluded(url) == false else {
            if url.isVolume() {
                return .unsupportedVolume
            } else {
                return .parentExcluded
            }
        }
        guard volumeFilter.isExcluded(url) == false else {
            if url.isVolume() {
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

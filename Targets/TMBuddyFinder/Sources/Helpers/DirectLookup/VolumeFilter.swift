import Foundation

struct VolumeFilter {
    
    let excludedVolumeUUIDs: [String]
    
    func isExcluded(_ url: URL) throws -> Bool {
        let resourceValues = try url.resourceValues(forKeys: [.volumeUUIDStringKey])
        
        guard let volumeUUID = resourceValues.volumeUUIDString else {
            return false
        }
        return excludedVolumeUUIDs.contains(volumeUUID)
    }
}

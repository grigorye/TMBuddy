import Foundation

struct VolumeFilter {
    
    let excludedVolumeUUIDs: [String]
    
    func isExcluded(_ url: URL) -> Bool {
        do {
            let resourceValues = try url.resourceValues(forKeys: [.volumeUUIDStringKey])
            
            guard let volumeUUID = resourceValues.volumeUUIDString else {
                return false
            }
            return excludedVolumeUUIDs.contains(volumeUUID)
        } catch {
            dump((error, path: url.path), name: "volumeUUIDFailed")
            return false
        }
    }
}

import Foundation

struct UnsupportedVolumeFilter {
    
    func isExcluded(_ url: URL) -> Bool {
        do {
            return try url.resourceValues(forKeys: [.volumeIsLocalKey]).volumeIsLocal == false
        } catch {
            dump((error, path: url.path), name: "volumeIsLocalFailed")
            return false
        }
    }
}

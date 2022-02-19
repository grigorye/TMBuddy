import Foundation

extension URL {
    func isVolume() throws -> Bool {
        return try resourceValues(forKeys: [.isVolumeKey]).isVolume == true
    }
}

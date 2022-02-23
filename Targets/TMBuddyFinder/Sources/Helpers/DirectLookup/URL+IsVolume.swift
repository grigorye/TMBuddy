import Foundation

extension URL {
    func isVolume() -> Bool {
        do {
            return try resourceValues(forKeys: [.isVolumeKey]).isVolume == true
        } catch {
            dump((error, path: self.path), name: "isVolumeResourceValueFailed")
            return false
        }
    }
    
    func volumeUUID() -> String? {
        do {
            return try resourceValues(forKeys: [.volumeUUIDStringKey]).volumeUUIDString
        } catch {
            dump((error, path: self.path), name: "volumeUUIDStringResourceValueFailed")
            return nil
        }
    }
}

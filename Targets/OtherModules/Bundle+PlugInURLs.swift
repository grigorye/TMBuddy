import Foundation

extension Bundle {
    
    func plugInURLs(withExtension pathExtension: String?) -> [URL]? {
        guard let builtInPlugInsURL = Bundle.main.builtInPlugInsURL else {
            dump(self, name: "buildInPlugInsDoesNotExist")
            return nil
        }
        do {
            return try FileManager.default
                .contentsOfDirectory(at: builtInPlugInsURL, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == pathExtension }
        } catch {
            dump((error, bundle: self, plugInsDirectory: builtInPlugInsURL.path), name: "error")
            return nil
        }
    }
}

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
    
    var plugInRelativeAppBundle: Bundle? {
        let plugInsURL = bundleURL.deletingLastPathComponent() // .app/Contents/PlugIns
        guard plugInsURL.lastPathComponent == "PlugIns" else {
            dump(bundlePath, name: "plugInPathCheckFailed")
            return nil
        }
        let appBundleURL = plugInsURL
            .deletingLastPathComponent() // .app/Contents
            .deletingLastPathComponent() // .app
        guard let appBundle = Bundle(url: appBundleURL) else {
            dump(plugInsURL.path, name: "bundleAtPathFailed")
            return nil
        }
        guard appBundle.builtInPlugInsURL?.absoluteURL == plugInsURL.absoluteURL else {
            dump((builtInPlugIns: appBundle.builtInPlugInsURL, bundle: plugInsURL), name: "appBundleURLSanityCheckFailed")
            return nil
        }
        return appBundle
    }
}

import Foundation

var plugInURL: URL? {
    guard let plugInURL = Bundle.main.plugInURLs(withExtension: "appex")?.last else {
        dump(Bundle.main.bundlePath, name: "missingAppex")
        return nil
    }
    return plugInURL
}

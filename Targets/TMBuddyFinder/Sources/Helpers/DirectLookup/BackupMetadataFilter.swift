import Foundation
import CoreServices

class BackupMetadataFilter {
    
    func isExcluded(_ url: URL) -> Bool {
        let parentPaths = parentPaths(for: url)
        let parentURLs = parentPaths.map { URL(fileURLWithPath: $0, isDirectory: false) }
        for url in parentURLs {
            if metadataReader.excludedBasedOnMetadata(url) {
                return true
            }
        }
        return false
    }
}

func parentPaths(for url: URL) -> [String] {
    url.pathComponents.reduce([String](), { (parentPaths: [String], component: String) -> [String] in
        assert(component != "")
        assert((component == "/") || !component.contains("/"))
        let prefix: String = {
            if component == "/" {
                assert(parentPaths.last == nil)
                return ""
            } else {
                guard let previousPath = parentPaths.last else {
                    fatalError()
                }
                guard previousPath != "/" else {
                    return "/"
                }
                return previousPath + "/"
            }
        }()
        let nextPath = prefix + component
        assert(nextPath.hasPrefix("/"))
        assert(url.path.hasPrefix(nextPath))
        return parentPaths + [nextPath]
    })
}

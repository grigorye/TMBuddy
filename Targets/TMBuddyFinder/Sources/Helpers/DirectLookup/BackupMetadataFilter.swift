import Foundation
import CoreServices

class BackupMetadataFilter {
    
    func isExcluded(_ url: URL) -> Bool {
        let parentPaths = parentPaths(for: url)
        let parentURLs = parentPaths.map { URL(fileURLWithPath: $0, isDirectory: false) }
        for url in parentURLs {
            if excludedBasedOnMetadata(url) {
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
                                                     
func excludedBasedOnMetadata(_ url: URL) -> Bool {
    let attribute = readStringMDItemAttribute("com_apple_backup_excludeItem", from: url)
    return attribute == "com.apple.backupd"
}

func readStringMDItemAttribute(_ name: String, from url: URL) -> String? {
    
    guard let item = MDItemCreateWithURL(nil, url as CFURL) else {
        dump(url, name: "unreadableURL")
        return nil
    }
    
    let attributeCFRef = MDItemCopyAttribute(item, name as CFString)
    
    dump((name, CFRef: attributeCFRef, path: url.path), name: "attribute")
    
    guard let attribute = attributeCFRef as? String? else {
        dump(attributeCFRef, name: "nonStringAttribute")
        return nil
    }
    
    return attribute
}

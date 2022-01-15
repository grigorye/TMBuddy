import Foundation

struct MDItemBackupController {
    func excludedBasedOnMetadata(_ url: URL) -> Bool {
        excludedBasedOnMDItemAttribute(url)
    }
}

func excludedBasedOnMDItemAttribute(_ url: URL) -> Bool {
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

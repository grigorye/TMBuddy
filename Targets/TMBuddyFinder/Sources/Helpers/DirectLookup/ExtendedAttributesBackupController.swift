import Foundation

struct ExtendedAttributesBackupController {
    
    func excludedBasedOnMetadata(_ url: URL) -> Bool {
        excludedBasedOnExtendedAttributes(url)
    }
    
    func setExcluded(_ excluded: Bool, urls: [URL]) async throws {
        dump((excluded, paths: urls.map { $0.path }), name: "excluded")
        for url in urls {
            if excluded {
                addExcludedBasedOnExtendedAttributes(url)
            } else {
                removeExcludedBasedOnExtendedAttributes(url)
            }
        }
    }
}

enum ExtendedAttributeForExcludingFromBackup {
    static let name = "com.apple.metadata:com_apple_backup_excludeItem"
    static let value = "com.apple.backupd"
}

func excludedBasedOnExtendedAttributes(_ url: URL) -> Bool {
    do {
        let attribute = try url.extendedAttribute(forName: ExtendedAttributeForExcludingFromBackup.name)
        let valueMatches = String(data: attribute, encoding: .utf8) == ExtendedAttributeForExcludingFromBackup.value
        return valueMatches
    } catch {
        switch error {
        case POSIXError.ENOATTR:
            return false
        default:
            dump(error, name: "error")
            return false
        }
    }
}

func addExcludedBasedOnExtendedAttributes(_ url: URL) {
    debug { dump(url.path, name: "path") }
    do {
        try addStringExtendedAttribute(
            ExtendedAttributeForExcludingFromBackup.name,
            value: ExtendedAttributeForExcludingFromBackup.value,
            to: url
        )
    } catch {
        dump((error, path: url.path), name: "error")
    }
}

func removeExcludedBasedOnExtendedAttributes(_ url: URL) {
    debug { dump(url.path, name: "path") }
    do {
        try url.removeExtendedAttribute(forName: ExtendedAttributeForExcludingFromBackup.name)
    } catch {
        dump((error, path: url.path), name: "error")
    }
}

func addStringExtendedAttribute(_ name: String, value: String, to url: URL) throws {
    debug { dump((name: name, value: value, path: url.path), name: "args") }
    guard let data = value.data(using: .utf8) else {
        throw dump(Error.invalidStringValue(value: value, url: url, name: name), name: "error")
    }
    try url.setExtendedAttribute(data: data, forName: name)
}

private enum Error: Swift.Error {
    case invalidStringValue(value: String, url: URL, name: String)
}

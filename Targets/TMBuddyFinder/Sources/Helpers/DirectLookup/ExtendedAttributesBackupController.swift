import Foundation

struct ExtendedAttributesBackupController {
    
    func excludedBasedOnMetadata(_ url: URL) -> Bool {
        excludedBasedOnExtendedAttributes(url)
    }
    
    func setExcluded(_ excluded: Bool, urls: [URL]) async throws {
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
            dump(error)
            return false
        }
    }
}

func addExcludedBasedOnExtendedAttributes(_ url: URL) {
    do {
        try addStringExtendedAttribute(
            ExtendedAttributeForExcludingFromBackup.name,
            value: ExtendedAttributeForExcludingFromBackup.value,
            to: url
        )
    } catch {
        dump((error: error, path: url.path))
    }
}

func removeExcludedBasedOnExtendedAttributes(_ url: URL) {
    do {
        try url.removeExtendedAttribute(forName: ExtendedAttributeForExcludingFromBackup.name)
    } catch {
        dump((error: error, path: url.path))
    }
}

func addStringExtendedAttribute(_ name: String, value: String, to url: URL) throws {
    guard let data = value.data(using: .utf8) else {
        throw dump(Error.invalidStringValue(value: value, url: url, name: name))
    }
    try url.setExtendedAttribute(data: data, forName: name)
}

private enum Error: Swift.Error {
    case invalidStringValue(value: String, url: URL, name: String)
}

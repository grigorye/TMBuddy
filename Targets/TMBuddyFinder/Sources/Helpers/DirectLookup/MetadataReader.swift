import Foundation

protocol MetadataReader {
    func excludedBasedOnMetadata(_ url: URL) -> Bool
}

extension MDItemBackupController: MetadataReader {}
extension ExtendedAttributesBackupController: MetadataReader {}

var metadataReader: MetadataReader {
    UserDefaults.standard.bool(forKey: DefaultsKey.forceMDItemMetadataReader)
    ? MDItemBackupController()
    : ExtendedAttributesBackupController()
}

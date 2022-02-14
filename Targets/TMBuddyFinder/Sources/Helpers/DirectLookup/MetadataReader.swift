import Foundation

protocol MetadataReader {
    func excludedBasedOnMetadata(_ url: URL) -> Bool
}

extension ExtendedAttributesBackupController: MetadataReader {}

var metadataReader: MetadataReader {
    ExtendedAttributesBackupController()
}

import Foundation

protocol MetadataReader {
    func excludedBasedOnMetadata(_ url: URL) -> Bool
}

extension MDItemBackupController: MetadataReader {}
extension ExtendedAttributesBackupController: MetadataReader {}

import Foundation

protocol MetadataWriter {
    func setExcluded(_ value: Bool, urls: [URL]) throws
}

extension TMUtilLauncher: MetadataWriter {}
extension ExtendedAttributesBackupController: MetadataWriter {}

var metadataWriter: MetadataWriter {
    UserDefaults.standard.bool(forKey: DefaultsKey.forceTMUtilMetadataWriter)
    ? TMUtilLauncher()
    : ExtendedAttributesBackupController()
}

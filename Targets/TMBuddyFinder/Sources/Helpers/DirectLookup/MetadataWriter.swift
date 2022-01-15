import Foundation

protocol MetadataWriter {
    func setExcluded(_ value: Bool, urls: [URL]) async throws
}

extension TMUtilLauncher: MetadataWriter {}
extension ExtendedAttributesBackupController: MetadataWriter {}

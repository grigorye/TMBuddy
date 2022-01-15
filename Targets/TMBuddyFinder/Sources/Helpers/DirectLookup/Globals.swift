import Foundation

var metadataReader: MetadataReader {
    UserDefaults.standard.bool(forKey: "ForceMDItemMetadataReader")
    ? MDItemBackupController()
    : ExtendedAttributesBackupController()
}

var metadataWriter: MetadataWriter {
    UserDefaults.standard.bool(forKey: "ForceTMUtilMetadataWriter")
    ? TMUtilLauncher()
    : ExtendedAttributesBackupController()
}

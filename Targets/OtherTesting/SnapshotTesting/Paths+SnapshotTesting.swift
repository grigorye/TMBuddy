import Foundation

func snapshotDirectory(forFile file: String) -> String {
    let fileUrl = URL(fileURLWithPath: file, isDirectory: false)
    let snapshotDirectoryUrl = fileUrl
        .deletingPathExtension()
        .appendingPathComponent(environmentSpecificRelativeSnapshotsPath())
    return snapshotDirectoryUrl.path
}

func environmentSpecificRelativeSnapshotsPath() -> String {
    let osVersion = ProcessInfo.processInfo.operatingSystemVersion
    return [
        "macOS-\(osVersion.majorVersion).\(osVersion.minorVersion)"
    ].joined(separator: "/")
}

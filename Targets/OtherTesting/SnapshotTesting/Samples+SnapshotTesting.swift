import SnapshotTesting
import XCTest
import Foundation

public func assertSnapshot<Value, Format>(
    matching value: @autoclosure () throws -> Value,
    as snapshotting: Snapshotting<Value, Format>,
    named name: String? = nil,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let failure = verifySnapshot(
        matching: try value(),
        as: snapshotting,
        named: name,
        record: recording,
        timeout: timeout,
        file: file,
        testName: testName,
        line: line
    )
    guard let message = failure else { return }
    XCTFail(message, file: file, line: line)
}

public func verifySnapshot<Value, Format>(
    matching value: @autoclosure () throws -> Value,
    as snapshotting: Snapshotting<Value, Format>,
    named name: String? = nil,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) -> String? {
    let snapshotEnvironment = SnapshotEnvironment()
    let snapshotDirectory = snapshotDirectory(forFile: "\(file)")
    
    return SnapshotTesting.verifySnapshot(
        matching: try value(),
        as: Snapshotting(wrapping: snapshotting, prependingPathExtension: snapshotEnvironment.nameSuffix),
        named: name,
        record: recording,
        snapshotDirectory: snapshotDirectory,
        timeout: timeout,
        file: file,
        testName: testName,
        line: line
    )
}

extension Snapshotting {
    init(wrapping: Self, prependingPathExtension: String) {
        self.init(
            pathExtension: prependingPathExtension + "." + wrapping.pathExtension!,
            diffing: wrapping.diffing,
            asyncSnapshot: wrapping.snapshot
        )
    }
}

struct SnapshotEnvironment {
    
    var nameSuffix: String {
        scaleFactorSuffix
    }
}

let scaleFactorSuffix: String = {
    let scaleFactor = NSScreen.main!.backingScaleFactor
    guard scaleFactor != 1.0 else {
        return ""
    }
    switch scaleFactor {
    case let rounded where scaleFactor == scaleFactor.rounded():
        return "@\(Int(rounded))x"
    default:
        return "@\(scaleFactor)x"
    }
}()

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

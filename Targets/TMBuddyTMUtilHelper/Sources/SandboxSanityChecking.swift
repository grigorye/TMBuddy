import Foundation

func checkSandboxSanity(writablePath: String, readOnlyPath: String) throws {
    guard fileManager.isWritableFile(atPath: writablePath) == true else {
        throw SandboxSanityCheckingError.fileIsNotWriteable(atPath: writablePath)
    }
    guard fileManager.isWritableFile(atPath: readOnlyPath) == false else {
        throw SandboxSanityCheckingError.fileIsNotReadOnly(atPath: readOnlyPath)
    }
}

enum SandboxSanityCheckingError: Swift.Error {
    case fileIsNotWriteable(atPath: String)
    case fileIsNotReadOnly(atPath: String)
}

private let fileManager = FileManager.default

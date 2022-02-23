import AppKit
import Foundation
import os

class TMUtilPrivileged {
    
    func version() async throws -> String {
        try await withProxy { proxy, continuation in
            proxy.versionAsync { version in
                continuation.resume(returning: version)
            }
        }
    }
    
    func checkSanity() async throws {
        try await withProxy { (proxy, continuation: CheckedContinuation<Void, Error>) in
            let writablePath = "/Library/Preferences/com.apple.TimeMachine.plist"
            let readOnlyPath = "/Library"
            assert(FileManager.default.isWritableFile(atPath: writablePath) == false)
            assert(FileManager.default.isWritableFile(atPath: readOnlyPath) == false)
            proxy.checkSanityAsync(writablePath: writablePath, readOnlyPath: readOnlyPath) { error in
                continuation.resume(with: Result(error: error))
            }
        }
    }

    func setExcluded(_ value: Bool, privilege: TMPrivilegedExclusionKind, urls: [URL]) async throws {
        try await withProxy { (proxy, continuation: CheckedContinuation<Void, Error>) in
            let abbreviatedPaths: [String] = urls.paths.map { $0.abbreviatingWithTildeInPath(ignoringSandbox: true) }
            dump(abbreviatedPaths, name: "abbreviatedPaths")
            proxy.setExcluded(value, privilege: privilege, paths: abbreviatedPaths) { error in
                continuation.resume(with: Result(error: error))
            }
        }
    }
    
    private func withProxy<T>(block: (TMUtilHelperXPC, _ continuation: CheckedContinuation<T, Error>) -> Void) async throws -> T {
        try await newTMUtilHelperXPCConnection().perform { (proxy: TMUtilHelperXPC, continuation) in
            block(proxy, continuation)
        }
    }
}

private func newTMUtilHelperXPCConnection() -> NSXPCConnection {
    .init(machServiceName: helperMachServiceName, options: .privileged)
}

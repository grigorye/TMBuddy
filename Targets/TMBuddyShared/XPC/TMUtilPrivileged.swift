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
        return try await withProxy { proxy, continuation in
            let writablePath = "/Library/Preferences/com.apple.TimeMachine.plist"
            let readOnlyPath = "/Library"
            assert(FileManager.default.isWritableFile(atPath: writablePath) == false)
            assert(FileManager.default.isWritableFile(atPath: readOnlyPath) == false)
            return proxy.checkSanityAsync(writablePath: writablePath, readOnlyPath: readOnlyPath) { error in
                continuation.resume(with: Result(error: error))
            }
        }
    }

    func setExcludedByPath(_ value: Bool, urls: [URL]) async throws {
        try await withProxy { (proxy, continuation: CheckedContinuation<Void, Error>) in
            let abbreviatedPaths: [String] = urls.paths.map { $0.abbreviatingWithTildeInPath(ignoringSandbox: true) }
            dump(abbreviatedPaths, name: "abbreviatedPaths")
            proxy.setExcludedByPath(value, paths: abbreviatedPaths) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
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

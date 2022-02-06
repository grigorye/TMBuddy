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
    
    func setExcludedByPath(_ value: Bool, urls: [URL]) async throws {
        try await withProxy { (proxy, continuation: CheckedContinuation<Void, Error>) in
            proxy.setExcludedByPath(value, paths: urls.paths) { error in
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

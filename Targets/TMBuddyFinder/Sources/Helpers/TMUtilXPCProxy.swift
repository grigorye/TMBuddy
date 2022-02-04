import SharedKit
import AppKit
import Foundation
import os

class TMUtilXPCMetadataWriter: MetadataWriter {
    func setExcluded(_ value: Bool, urls: [URL]) async throws {
        tmUtilXPC.callProxy { proxy in
            proxy.setExcluded(value, paths: urls.map(\.path))
        }
    }
}

/// Live XPC connection for collection logs.
private let tmUtilXPC: SharedKit.XPC<MetadataWriterInterface> = .init(
    configuration: .machServiceName("com.grigorye.TMBuddy.TMUtilHelper", options: .privileged),
    errorHandler: tmUtilXPCErrorHandler
)

private func tmUtilXPCErrorHandler(error: Error) {
    DispatchQueue.main.async {
        dump(error, name: "error")
        if NSApp.presentError(error) { return }
    }
}

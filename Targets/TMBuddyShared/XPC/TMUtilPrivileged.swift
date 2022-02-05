import SharedKit
import AppKit
import Foundation
import os

class TMUtilPrivileged {
    func setExcludedByPath(_ value: Bool, urls: [URL]) async throws {
        tmUtilHelperXPC.callProxy { proxy in
            proxy.setExcludedByPath(value, paths: urls.map(\.path))
        }
    }
}

private let tmUtilHelperXPC: SharedKit.XPC<TMUtilHelperXPC> = .init(
    configuration: .machServiceName("com.grigorye.TMBuddy.TMUtilHelper", options: .privileged),
    errorHandler: tmUtilHelperXPCErrorHandler
)

private func tmUtilHelperXPCErrorHandler(_ error: Error) {
    DispatchQueue.main.async {
        dump(error, name: "error")
        if NSApp.presentError(error) { return }
    }
}

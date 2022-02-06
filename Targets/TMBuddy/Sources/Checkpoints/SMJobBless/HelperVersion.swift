import Foundation

func helperVersion() async throws -> String {
    try await NSXPCConnection(machServiceName: helperMachServiceName, options: .privileged)
        .perform { (proxy: CommonHelperXPC, continuation) in
            proxy.versionAsync { version in
                continuation.resume(returning: version)
            }
        }
}

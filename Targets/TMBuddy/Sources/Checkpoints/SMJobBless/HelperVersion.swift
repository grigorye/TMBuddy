import Foundation

func helperVersion() async throws -> String {
    try await performCommonHelperXPC { (proxy: CommonHelperXPC, continuation) in
        proxy.versionAsync { version in
            continuation.resume(returning: version)
        }
    }
}

func performCommonHelperXPC<T>(
    block: (CommonHelperXPC, CheckedContinuation<T, Error>) -> Void
) async throws -> T {
    try await NSXPCConnection(machServiceName: helperMachServiceName, options: .privileged)
        .perform(block: block)
}

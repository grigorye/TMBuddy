import Foundation

func performCommonHelperXPC<T>(
    block: (CommonHelperXPC, CheckedContinuation<T, Error>) -> Void
) async throws -> T {
    try await NSXPCConnection(machServiceName: helperMachServiceName, options: .privileged)
        .perform(block: block)
}

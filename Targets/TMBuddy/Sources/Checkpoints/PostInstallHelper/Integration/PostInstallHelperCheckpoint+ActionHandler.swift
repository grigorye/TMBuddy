import AppKit

struct PostInstallHelperCheckpointActionHandler: PostInstallHelperCheckpointActions {
    
    func installMacOSSupport() {
        let task = Task {
            try await performCommonHelperXPC { (proxy: CommonHelperXPC, continuation) in
                proxy.postInstallAsync(sourceBundlePath: postInstallHelperSourceBundlePath) { error in
                    continuation.resume(with: Result(error: error))
                }
            }
        }
        Task {
            let result = await task.result
            dump(result, name: "postInstallResult")
        }
    }
}
